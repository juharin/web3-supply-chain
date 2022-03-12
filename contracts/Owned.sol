// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

// Not supported
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Owned { //is Ownable {
    //function isOwner() internal view returns(bool) {
    //    return owner() == msg.sender;
    //}

    address public _owner;

    constructor () {
        _owner = msg.sender;
    }

    /**
    * @dev Throws if called by any account other than the owner.
    */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
    * @dev Returns true if the caller is the current owner.
    */
    function isOwner() public view returns (bool) {
        return (msg.sender == _owner);
    }
}
