// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";
import "../lib/openzeppelin-contracts/contracts/utils/Strings.sol";

contract Properties is ERC1155 {
    uint256 public constant House = 1;
    uint256 public constant Land = 2;

    constructor(address _seller) ERC1155("https://ipfs.io/ipfs/bafybeigxgjr3bre3vvro7duzpz2j5tfrhwnarlqw6yq5cce6fo5qh3u7yq/{id}.json") {
        _mint(_seller, House, 5, "");
        _mint(_seller, Land, 15, "");
    }

    function uri(uint256 _tokenid) override public pure returns (string memory) {
        return string(
            abi.encodePacked(
                "https://ipfs.io/ipfs/bafybeihjjkwdrxxjnuwevlqtqmh3iegcadc32sio4wmo7bv2gbf34qs34a/",
                Strings.toString(_tokenid),".json"
            )
        );
    }
}