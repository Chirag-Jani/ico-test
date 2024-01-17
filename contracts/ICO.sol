// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// npx hardhat verify --network sepolia 0x79ab5B66F34e73EAcd1f016C7Bdd316617C799b1
// 0x79ab5B66F34e73EAcd1f016C7Bdd316617C799b1
// https://sepolia.etherscan.io/address/0x79ab5B66F34e73EAcd1f016C7Bdd316617C799b1#code
// https://repo.sourcify.dev/contracts/full_match/11155111/0x79ab5B66F34e73EAcd1f016C7Bdd316617C799b1/
contract MyToken is ERC20 {
    constructor() ERC20("MyToken", "MTK") {
        _mint(msg.sender, 1000000 * 10 ** 18); // Mint 1,000,000 tokens to the contract deployer
    }
}

// npx hardhat verify --network sepolia 0x3f955f8a9b4a9e71D23c6eC91339df9eAb29A4dC "0x79ab5B66F34e73EAcd1f016C7Bdd316617C799b1" "1000000000000000000"
// 0x3f955f8a9b4a9e71D23c6eC91339df9eAb29A4dC
// https://repo.sourcify.dev/contracts/full_match/11155111/0x3f955f8a9b4a9e71D23c6eC91339df9eAb29A4dC/
// https://sepolia.etherscan.io/address/0x3f955f8a9b4a9e71D23c6eC91339df9eAb29A4dC#code
contract ICO {
    address public admin;
    MyToken public token;
    uint256 public tokenPrice;
    uint256 public tokensSold;

    event TokenPurchased(
        address indexed buyer,
        uint256 amount,
        uint256 totalTokensSold
    );

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    constructor(address _tokenAddress, uint256 _tokenPrice) {
        admin = msg.sender;
        token = MyToken(_tokenAddress);
        tokenPrice = _tokenPrice;
    }

    function buyTokens(uint256 _numberOfTokens) external payable {
        require(
            msg.value == _numberOfTokens * tokenPrice,
            "Incorrect amount sent"
        );
        require(
            token.balanceOf(address(this)) >= _numberOfTokens,
            "Not enough tokens available"
        );

        token.transfer(msg.sender, _numberOfTokens);
        tokensSold += _numberOfTokens;

        emit TokenPurchased(msg.sender, _numberOfTokens, tokensSold);
    }

    function withdrawFunds() external onlyAdmin {
        payable(admin).transfer(address(this).balance);
    }
}
