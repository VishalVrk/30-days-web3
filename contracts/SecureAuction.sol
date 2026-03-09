// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract SecureAuction {
    address public owner;
    uint256 public auctionEnd;

    address public highestBidder;
    uint256 public highestBid;

    uint256 public minIncrement = 0.01 ether;

    bool public ended;

    mapping(address => uint256) public pendingReturns;

    bool private locked;

    modifier noReentrancy() {
        require(!locked, "Reentrancy detected");
        locked = true;
        _;
        locked = false;
    }

    event BidPlaced(address bidder, uint256 amount);
    event Withdrawal(address bidder, uint256 amount);
    event AuctionEnded(address winner, uint256 amount);

    constructor(uint256 duration) {
        owner = msg.sender;
        auctionEnd = block.timestamp + duration;
    }

    function bid() external payable {

        require(block.timestamp < auctionEnd, "Auction ended");

        require(
            msg.value >= highestBid + minIncrement,
            "Bid increment too small"
        );

        if (highestBid != 0) {
            pendingReturns[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;

        emit BidPlaced(msg.sender, msg.value);
    }

    function withdraw() external noReentrancy {

        uint256 amount = pendingReturns[msg.sender];

        require(amount > 0, "No funds");

        pendingReturns[msg.sender] = 0;

        (bool success, ) = msg.sender.call{value: amount}("");

        require(success, "Transfer failed");

        emit Withdrawal(msg.sender, amount);
    }

    function endAuction() external {

        require(block.timestamp >= auctionEnd, "Auction still active");
        require(!ended, "Already ended");

        ended = true;

        (bool success, ) = owner.call{value: highestBid}("");

        require(success, "Transfer failed");

        emit AuctionEnded(highestBidder, highestBid);
    }

}