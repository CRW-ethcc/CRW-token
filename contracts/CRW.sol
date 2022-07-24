// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CRW is ERC20 {
    constructor(uint256 initialSupply) ERC20("CRW", "CRW") {
        _mint(msg.sender, initialSupply);
    }

    /// @notice using a unix timestamp to book a restaurant is probably not the best solution
    /// user => (restaurant => timeStamp)
    mapping(address => mapping(address => uint)) public appointments;

    /// restaurant => capacity
    mapping(address => uint) public capacities;

    /// @dev returns true if the user has an appointment at the restaurant
    function isAppointment(address  _restaurant) public view returns (bool) {
        return appointments[msg.sender][_restaurant] != 0;
    }

    /// @dev attempts to make an appointment at the restaurant
    /// @notice this doesn't yet check for restaurant capacity
    function book(address _restaurant, uint _timeStamp) public {
        require(!isAppointment(_restaurant), "You already have an appointment");
        appointments[msg.sender][_restaurant] = _timeStamp;
    }

    /// @dev attempts to cancel an appointment at the restaurant
    function cancelAppointment(address _restaurant) public {
        require(isAppointment(_restaurant), "You don't have an appointment");
        appointments[msg.sender][_restaurant] = 0;
    }
}
