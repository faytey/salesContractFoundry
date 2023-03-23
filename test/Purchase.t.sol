// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "../src/Purchase.sol";
import "../src/Properties.sol";


contract PurchaseTest is Test{
    Purchase public purchase;
    Properties public properties;
    uint256 mainnetFork;
    address internal DAI_USER = 0xaD0135AF20fa82E106607257143d0060A7eB5cBf;

    //Supported Tokens
    IERC20 USDC = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    IERC20 DAI = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    IERC20 LINK = IERC20(0x514910771AF9Ca656af840dff83E8264EcF986CA);
    IERC20 UNI = IERC20(0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984);
    IERC20 USDT = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);

    address owner = mkaddr("owner");

    function setUp() public {
        mainnetFork = vm.createSelectFork('https://eth-mainnet.g.alchemy.com/v2/lh2i9x_uHZnURi_yOJnAU49bIQWDsJ-w');
        purchase = new Purchase();
        properties = new Properties(address(purchase));
    }

     function testCanSelectFork() public {
        // select the fork
        vm.selectFork(mainnetFork);
        assertEq(vm.activeFork(), mainnetFork);

        // from here on data is fetched from the `mainnetFork` if the EVM requests it and written to the storage of `mainnetFork`
    }

    function testBalance() public {
        properties.balanceOf(address(purchase), 1);
        properties.balanceOf(address(purchase), 2);
    }

    function testPurchasePropertyWithETH() public {
        vm.deal(owner, 50 ether);
        properties.balanceOf(address(purchase), 1);
        // vm.prank(0xaD0135AF20fa82E106607257143d0060A7eB5cBf);
        vm.startPrank(owner);
        purchase.purchasePropertyWithETH{value: 7 ether}(1, 2);
        properties.balanceOf(owner, 1);
        vm.stopPrank();
        properties.balanceOf(address(purchase), 1);
        console.log(address(purchase).balance);
    }

    function testGetPriceFeeds() public {
        testCanSelectFork();
        vm.startPrank(0xaD0135AF20fa82E106607257143d0060A7eB5cBf);
        purchase.getUSDC();
        purchase.getDAI();
        purchase.getLINK();
        purchase.getUNI();
        purchase.getUSDT();
        vm.stopPrank();
    }

    function testPurchaseWithUSDC() public {
        vm.prank(0xaD0135AF20fa82E106607257143d0060A7eB5cBf);
        purchase.purchaseWithUSDC(2,1);
        console.log(properties.balanceOf(address(purchase), 2));
    }
    function testPurchaseWithDAI() public {
        vm.prank(0xaD0135AF20fa82E106607257143d0060A7eB5cBf);
        // DAI.approve(address(purchase), 4000000000000000000);
        // DAI.allowance(0xaD0135AF20fa82E106607257143d0060A7eB5cBf,address(purchase));
        purchase.purchaseWithDAI(1,1);
        console.log(properties.balanceOf(address(purchase), 1));
    }

    function testPurchaseWithLINK() public {
        vm.prank(0x41318419CFa25396b47A94896FfA2C77c6434040);
        purchase.purchaseWithLINK(2,1);
        console.log(properties.balanceOf(address(purchase), 2));
    }

    function testPurchaseWithUSDT() public {
        vm.prank(0x41318419CFa25396b47A94896FfA2C77c6434040);
        purchase.purchaseWithUSDT(1,1);
        console.log(properties.balanceOf(address(purchase), 1));
    }

    function testPurchaseWithUNI() public {
        vm.prank(0x5F246D7D19aA612D6718D27c1dA1Ee66859586b0);
        purchase.purchaseWithUNI(2,1);
        console.log(properties.balanceOf(address(purchase), 2));
    }






       function mkaddr(string memory name) public returns (address) {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(name))))
        );
        vm.label(addr, name);
        return addr;
    }
}