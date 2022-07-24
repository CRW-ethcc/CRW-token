// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract CRW is ERC20, Ownable, AccessControl {

    uint256 public amount_of_token_for_book = 10 * decimals(); // we can change this value later with setAmount()
    bytes32 public constant RESTAURANT = keccak256("RESTAURANT");

    /// @notice using a unix timestamp to book a restaurant is probably not the best solution
    /// user => (restaurant => timeStamp)
    mapping(address => mapping(address => uint)) public appointments;

    /// restaurant => capacity
    mapping(address => uint) public capacities;

    constructor() ERC20("CRW", "CRW") {
        // _mint(msg.sender, initialSupply);
        _grantRole(
            DEFAULT_ADMIN_ROLE,
            msg.sender
        );
        _grantRole(RESTAURANT, 0x4AC7fcF17B690b600c86C2e6049850663270E3C2); // just a test address to use for the first restaurant.
    }

    modifier onlyAdmin() {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "The account does not have DEFAULT_ADMIN_ROLE role.");
        _;
    }

    modifier onlyRestaurant() {
        require(hasRole(RESTAURANT, msg.sender), "The account does not have RESTAURANT role.");
        _;
    }

    function addRestaurant(address _newRestaurant) public onlyAdmin {
        _grantRole(RESTAURANT, _newRestaurant);
    }

    function verify(address _costumer) public onlyRestaurant {
        if(appointments[_costumer][_restaurant] != 0) {
            _mint(_costumer, amount_of_token_for_book);
        }
    }

    function setAmount(uint256 _newAmount) public onlyOwner {
        amount_of_token_for_book = _newAmount * decimals();
    }


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
