// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IFeeClaimer} from '../interfaces/IFeeClaimer.sol';


// https://developers.paraswap.network/smart-contracts#fee-claimer
library ParaswapClaimer {
  IFeeClaimer public constant ETHEREUM = IFeeClaimer(0xeF13101C5bbD737cFb2bF00Bbd38c626AD6952F7);

  IFeeClaimer public constant AVALANCHE = IFeeClaimer(0xbFcd68FD74B4B458961495F3392Bf96f46A29E67);

  IFeeClaimer public constant FANTOM = IFeeClaimer(0x4F14fE8c86A00D6DFB9e91239738499Fc0F587De);

  IFeeClaimer public constant POLYGON = IFeeClaimer(0x8b5cF413214CA9348F047D1aF402Db1b4E96c060);

  IFeeClaimer public constant ARBITRUM = IFeeClaimer(0xA7465CCD97899edcf11C56D2d26B49125674e45F);

  IFeeClaimer public constant OPTIMISM = IFeeClaimer(0xA7465CCD97899edcf11C56D2d26B49125674e45F);
}
