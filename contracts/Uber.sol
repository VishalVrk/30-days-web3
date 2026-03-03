// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract Uber{
    enum RideStatus{
        Requested,
        Accepted,
        Completed,
        Cancelled
    }

    struct Ride{
        address rider;
        address driver;
        uint256 fare;
        RideStatus status;
    }

    uint256 public rideCounter;

    mapping(uint256 => Ride) public rides;
    mapping(address => bool) public registeredDrivers;

    event DriverRegistered(address driver);
    event RideRequested(uint256 rideId, address rider, uint256 fare);
    event RideAccepted(uint256 rideId, address driver);
    event RideCompleted(uint256 rideId);

    // Register as driver
    function registerDriver() external {
        registeredDrivers[msg.sender] = true;
        emit DriverRegistered(msg.sender);
    }

    // Rider requests ride (sends ETH as fare)
    function requestRide() external payable {
        require(msg.value > 0, "Fare must be greater than 0");

        rideCounter++;

        rides[rideCounter] = Ride({
            rider: msg.sender,
            driver: address(0),
            fare: msg.value,
            status: RideStatus.Requested
        });

        emit RideRequested(rideCounter, msg.sender, msg.value);
    }

    // Driver accepts ride
    function acceptRide(uint256 rideId) external {
        require(registeredDrivers[msg.sender], "Not registered driver");

        Ride storage ride = rides[rideId];

        require(ride.status == RideStatus.Requested, "Ride not available");

        ride.driver = msg.sender;
        ride.status = RideStatus.Accepted;

        emit RideAccepted(rideId, msg.sender);
    }

    // Complete ride and pay driver
    function completeRide(uint256 rideId) external {
        Ride storage ride = rides[rideId];

        require(msg.sender == ride.driver, "Only driver can complete");
        require(ride.status == RideStatus.Accepted, "Ride not active");

        ride.status = RideStatus.Completed;

        payable(ride.driver).transfer(ride.fare);

        emit RideCompleted(rideId);
    }

}