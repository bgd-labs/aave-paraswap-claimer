// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


// https://developers.paraswap.network/smart-contracts#fee-claimer
library ParaswapClaimer {
  address public constant ETHEREUM = 0xeF13101C5bbD737cFb2bF00Bbd38c626AD6952F7;

  address public constant AVALANCHE = 0xbFcd68FD74B4B458961495F3392Bf96f46A29E67;

  address public constant FANTOM = 0x4F14fE8c86A00D6DFB9e91239738499Fc0F587De;

  address public constant POLYGON = 0x8b5cF413214CA9348F047D1aF402Db1b4E96c060;

  address public constant ARBITRUM = 0xA7465CCD97899edcf11C56D2d26B49125674e45F;

  address public constant OPTIMISM = 0xA7465CCD97899edcf11C56D2d26B49125674e45F;
}
