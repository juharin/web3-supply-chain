// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

import "./Item.sol";
import "./Owned.sol";

contract ItemManager is Owned {

    enum SupplyChainSteps{
        Created, 
        Paid, 
        Delivered
    }

    struct S_Item {
        ItemManager.SupplyChainSteps _step;
        string _identifier;
        Item _item;
    }
    
    mapping(uint => S_Item) public items;
    
    uint index;

    event SupplyChainStep(uint _itemIndex, uint _step, address _address);

    function createItem(string memory _identifier, uint _priceInWei) public onlyOwner {
        Item item = new Item(this, _priceInWei, index);
        items[index]._item = item;
        items[index]._step = SupplyChainSteps.Created;
        items[index]._identifier = _identifier;
        emit SupplyChainStep(index, uint(items[index]._step), address(item));
        index++;
    }

    function triggerPayment(uint _index) public payable {
        Item item = items[_index]._item;
        require(address(item) == msg.sender, "Items are only allowed to update themselves!");
        require(item.priceInWei() == msg.value, "Not paid yet!");
        require(items[_index]._step == SupplyChainSteps.Created, "Item is already further in the supply chain");
        items[_index]._step = SupplyChainSteps.Paid;
        emit SupplyChainStep(_index, uint(items[_index]._step), address(item));
    }

    function triggerDelivery(uint _index) public onlyOwner {
        Item item = items[_index]._item;
        require(items[_index]._step == SupplyChainSteps.Paid, "Item is already further in the supply chain");
        items[_index]._step = SupplyChainSteps.Delivered;
        emit SupplyChainStep(_index, uint(items[_index]._step), address(item));
    }
}
