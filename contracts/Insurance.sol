// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract Insurance {

    address public owner;
    uint256 public policyCounter;

    constructor() {
        owner = msg.sender;
    }

    struct Policy {
        address holder;
        uint256 premium;
        uint256 coverageAmount;
        bool active;
        bool claimFiled;
    }

    mapping(uint256 => Policy) public policies;

    event PolicyPurchased(uint256 policyId, address holder);
    event ClaimFiled(uint256 policyId);
    event ClaimApproved(uint256 policyId);
    event ClaimRejected(uint256 policyId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    function buyPolicy(uint256 coverageAmount) external payable {
        require(msg.value > 0, "Premium required");

        policyCounter++;

        policies[policyCounter] = Policy({
            holder: msg.sender,
            premium: msg.value,
            coverageAmount: coverageAmount,
            active: true,
            claimFiled: false
        });

        emit PolicyPurchased(policyCounter, msg.sender);
    }

    function fileClaim(uint256 policyId) external {
        Policy storage policy = policies[policyId];

        require(msg.sender == policy.holder, "Not policy holder");
        require(policy.active, "Policy inactive");
        require(!policy.claimFiled, "Claim already filed");

        policy.claimFiled = true;

        emit ClaimFiled(policyId);
    }

    function approveClaim(uint256 policyId) external onlyOwner {
        Policy storage policy = policies[policyId];

        require(policy.claimFiled, "No claim filed");

        policy.active = false;

        payable(policy.holder).transfer(policy.coverageAmount);

        emit ClaimApproved(policyId);
    }

    function rejectClaim(uint256 policyId) external onlyOwner {
        Policy storage policy = policies[policyId];

        require(policy.claimFiled, "No claim filed");

        policy.claimFiled = false;

        emit ClaimRejected(policyId);
    }
}