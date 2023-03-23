// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "../lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./Properties.sol";

contract Purchase is ERC1155Holder {
    Properties internal properties;
    uint256 public constant price = 3.5e18;
    address public owner;
    string public supportedTokens;

    //Supported Tokens
    IERC20 USDC = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    IERC20 DAI = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    IERC20 LINK = IERC20(0x514910771AF9Ca656af840dff83E8264EcF986CA);
    IERC20 UNI = IERC20(0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984);
    IERC20 USDT = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);

    constructor(){
        owner = msg.sender;
        supportedTokens = "USDC,DAI,LINK,UNI,USDT";
    }
    function getUSDC() public view returns (int256) {
        (, int256 basePrice, , , ) = AggregatorV3Interface(
            0x986b5E1e1755e3C2440e960477f25201B0a8bbD4
        ).latestRoundData();

        return basePrice;
    }

    function getDAI() public view returns (int256) {
        (, int256 basePrice, , , ) = AggregatorV3Interface(
            0x773616E4d11A78F511299002da57A0a94577F1f4
        ).latestRoundData();

        return basePrice;
    }

    function getLINK() public view returns (int256) {
        (, int256 basePrice, , , ) = AggregatorV3Interface(
            0xDC530D9457755926550b59e8ECcdaE7624181557
        ).latestRoundData();

        return basePrice;
    }

    function getUNI() public view returns (int256) {
        (, int256 basePrice, , , ) = AggregatorV3Interface(
            0xD6aA3D25116d8dA79Ea0246c4826EB951872e02e
        ).latestRoundData();

        return basePrice;
    }

    function getUSDT() public view returns (int256) {
        (, int256 basePrice, , , ) = AggregatorV3Interface(
            0xEe9F2375b4bdF6387aa8265dD4FB8F16512A1d46
        ).latestRoundData();

        return basePrice;
    }

    function purchaseWithUSDC(uint _tokenId, int _quantity) external {
        address recipient = msg.sender;
        uint256 quantity = uint256(_quantity);
        require(
            quantity <= USDC.balanceOf(msg.sender),
            "Insufficient USDC Amount"
        );
        USDC.transferFrom(recipient, address(this), quantity);
        int256 usdc = getUSDC();
        uint256 swapAmount = (price * quantity) / uint256(usdc);
        uint256 balance = properties.balanceOf(address(this), _tokenId);
        require(
            balance >= swapAmount,
            "Not enough funds, please try again later"
        );
        properties.safeTransferFrom((address(this)), msg.sender, _tokenId, quantity, "0x0");
    }

    function purchaseWithDAI(uint _tokenId, int _quantity) external {
        address recipient = msg.sender;
        uint256 quantity = uint256(_quantity);
        require(
            quantity <= DAI.balanceOf(msg.sender),
            "Insufficient DAI Amount"
        );
        DAI.transferFrom(recipient, address(this), quantity);
        int256 dai = getDAI();
        uint256 swapAmount = (price * quantity) / uint256(dai);
        uint256 balance = properties.balanceOf(address(this), _tokenId);
        require(
            balance >= swapAmount,
            "Not enough funds, please try again later"
        );
        properties.safeTransferFrom((address(this)), msg.sender, _tokenId, quantity, "0x0");
    }

    function purchaseWithLINK(uint _tokenId, int _quantity) external {
        address recipient = msg.sender;
        uint256 quantity = uint256(_quantity);
        require(
            quantity <= LINK.balanceOf(msg.sender),
            "Insufficient LINK Amount"
        );
        LINK.transferFrom(recipient, address(this), quantity);
        int256 link = getLINK();
        uint256 swapAmount = (price * quantity) / uint256(link);
        uint256 balance = properties.balanceOf(address(this), _tokenId);
        require(
            balance >= swapAmount,
            "Not enough funds, please try again later"
        );
        properties.safeTransferFrom((address(this)), msg.sender, _tokenId, quantity, "0x0");
    }

    function purchaseWithUNI(uint _tokenId, int _quantity) external {
        address recipient = msg.sender;
        uint256 quantity = uint256(_quantity);
        require(
            quantity <= UNI.balanceOf(msg.sender),
            "Insufficient UNI Amount"
        );
        UNI.transferFrom(recipient, address(this), quantity);
        int256 uni = getUNI();
        uint256 swapAmount = (price * quantity) / uint256(uni);
        uint256 balance = properties.balanceOf(address(this), _tokenId);
        require(
            balance >= swapAmount,
            "Not enough funds, please try again later"
        );
        properties.safeTransferFrom((address(this)), msg.sender, _tokenId, quantity, "0x0");
    }

    function purchaseWithUSDT(uint _tokenId, int _quantity) external {
        address recipient = msg.sender;
        uint256 quantity = uint256(_quantity);
        require(
            quantity <= USDT.balanceOf(msg.sender),
            "Insufficient USDT Amount"
        );
        USDT.transferFrom(recipient, address(this), quantity);
        int256 usdt = getUSDT();
        uint256 swapAmount = (price * quantity) / uint256(usdt);
        uint256 balance = properties.balanceOf(address(this), _tokenId);
        require(
            balance >= swapAmount,
            "Not enough funds, please try again later"
        );
        properties.safeTransferFrom((address(this)), msg.sender, _tokenId, quantity, "0x0");
    }

    function purchasePropertyWithETH(uint _tokenId, uint _quantity) external payable {
        require(msg.value == price * _quantity, "Insufficient Eth");
        properties.safeTransferFrom((address(this)), msg.sender, _tokenId, _quantity, "0x0");
    }

    //   function batchPurchaseWithUSDC(uint[] memory _tokenIds, uint[] memory _quantities) external {
    //     address recipient = msg.sender;
    //     // uint256[] memory quantities = uint256[] (_quantities);
    //     uint amount_ = 0;
    //     for(uint i = 0; i < _quantities.length; i++){
    //         amount_ += _quantities[i];
    //     }
    //     require(
    //         amount_ <= USDC.balanceOf(msg.sender),
    //         "Insufficient USDC Amount"
    //     );
    //     USDC.transferFrom(recipient, address(this), (price * amount_));
    //     int256 usdc = getUSDC();
    //     uint256 swapAmount = (price * amount_) / uint256(usdc);
    //     uint256[] memory balance = properties.balanceOfBatch([address(this), address(this)], _tokenIds);
    //     require(
    //         balance >= swapAmount,
    //         "Not enough funds, please try again later"
    //     );
    //     properties.safeBatchTransferFrom(address(this), msg.sender, _tokenIds, _quantities, "0x0");

    // }
    function purchaseBatchPropertiesWithETH(uint[] calldata _tokenIds, uint[] calldata _quantities) external payable {
        uint amount_ = 0;
        for(uint i = 0; i < _quantities.length; i++){
            amount_ += _quantities[i];
        }
        require(msg.value == price * amount_, "Insufficient Eth");
        properties.safeBatchTransferFrom(address(this), msg.sender, _tokenIds, _quantities, "0x0");
    }

    // receive() external payable {};
    // fallback() external payable {};
}