// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

import "./ItemManager.sol";

contract Item {
    
    uint public priceInWei;
    uint public paidWei;
    uint public index;

    ItemManager parentContract;

    constructor(ItemManager _parentContract, uint _priceInWei, uint _index) {
        priceInWei = _priceInWei;
        index = _index;
        parentContract = _parentContract;
    }

    receive() external payable {
        require(msg.value == priceInWei, "We don't support partial payments");
        require(paidWei == 0, "Item is already paid!");
        paidWei += msg.value;
        // Item contract has received the payment and forwards it
        // to ItemManager.triggerPayment() with the received value.
        // It's a low level call and so more risky but we'll check
        // the returned success boolean (other would be returned value).
        (bool success, ) = address(parentContract).call{
            value: msg.value
        }(abi.encodeWithSignature("triggerPayment(uint256)", index));
        require(success, "Payment forwarding did not work, cancelling");
    }

    fallback () external {}
}
