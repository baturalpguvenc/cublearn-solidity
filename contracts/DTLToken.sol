// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DTLToken is ERC20 {
	constructor(address initialHolder) ERC20("Digital Turkish Lira", "DTL") {
		_mint(initialHolder, 1000000000);
	}

    function decimals() public view virtual override returns (uint8) {
        return 0;
    }

    function approveMax(address spender) external returns (bool) {
        return approve(spender, totalSupply());
    }
}
