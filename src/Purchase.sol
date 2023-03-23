// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/openzeppelin-contracts/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "./Properties.sol";

contract Purchase is ERC1155Holder {
    Properties internal properties;
    uint256 public constant price = 3.5e18;
    address public owner;

    constructor(){
        owner = msg.sender;
    }

    function purchaseProperty(uint _tokenId, uint _quantity) external payable {
        require(msg.value == price * _quantity, "Insufficient Amount");
        properties.safeTransferFrom((address(this)), msg.sender, _tokenId, _quantity, "0x0");
    }

    function purchaseBatchProperties(uint[] calldata _tokenIds, uint[] calldata _quantities) external payable {
        uint amount_ = 0;
        for(uint i = 0; i < _quantities.length; i++){
            amount_ += _quantities[i];
        }
        require(msg.value == price * amount_, "Insufficient Amount");
        properties.safeBatchTransferFrom(address(this), msg.sender, _tokenIds, _quantities, "0x0");
    }

    // receive() external payable {};
    // fallback() external payable {};
}