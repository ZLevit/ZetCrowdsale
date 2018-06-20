pragma solidity ^0.4.23;


/**
 * @title ZCrowdsaleToken
 * @dev Very simple ERC20 Token that can be minted.
 * It is meant to be used in a crowdsale contract.
 */
contract ZetCrowsaleInfo
{
    // date converted using https://www.epochconverter.com/
    // ETH converted using https://www.cryps.info/en/Wei_to_ETH
    
    // Openning sale date 16-Jul-2018
    uint256 constant OPENNING_DT = 1531699200;
    
    // Closing sale date 17-Sep-2018 
    uint256 constant CLOSING_DT = 1537142400;
    
    // Rate 1 ETH = 5000 FRECN
    uint256 constant TOKEN_RATE = 5000;

    // HARD CAP -  maximum amount of WEI accepted in the crowdsale. 
    // 80'000 ETH in WEI
    uint256 constant WEI_HARD_CAP = 80000000000000000000000;

    // SOFT CAP -  minimum amount of wei accepted in the crowdsale. 
    // 4'000 ETH in WEI
    uint256 constant WEI_SOFT_CAP = 4000000000000000000000;
    
    // WEI - minimum ammount for purchase
    // 0.02 ETH in WEI.
    uint256 constant WEI_PURCHASE_MIN = 20000000000000000;
    
    // TOKEN_BONUS_FINALIZE - ammount allocated to team in token
    // 200'000'000 FRECN in WEI 
    uint256 constant TOKEN_BONUS_FINALIZE = 200000000000000000000000000;
    
    /*    maximum amount of wei accepted in the pre-sale. */    
    // 2'000 ETH in WEI
    uint256 constant PRESALE_WEI_CAP = 2000000000000000000000;
    // bonus 100% on Pre-ICO stage of ICO programm
    uint256 constant PRESALE_ONE_BONUS_RATE = 100;
    /* Pre-ICO closing date 16-Aug-2018*/
    uint256 constant PRESALE_CLOSING_DT = 1534377600;

    /* Stage one closing date 23-Aug-2018*/
    uint256 constant SALE_ONE_CLOSING_DT = 1534982400;
    // bonus 20% on 1th stage of ICO programm
    uint256 constant SALE_ONE_BONUS_RATE = 20;
    
    /* Stage two closing date 28-Aug-2018*/
    uint256 constant SALE_TWO_CLOSING_DT = 1535414400;
    // bonus 15% on 2th stage of ICO programm
    uint256 constant SALE_TWO_BONUS_RATE = 15;
    
    /* Stage three closing date 3-Sep-2018*/
    uint256 constant SALE_THREE_CLOSING_DT = 1535932800;
    // bonus 10% on 3th stage of ICO programm
    uint256 constant SALE_THREE_BONUS_RATE = 10;
    
    /* Stage four closing date 10-Sep-2018*/
    uint256 constant SALE_FOUR_CLOSING_DT = 1536537600;
    // bonus 5% on 4th stage of ICO programm
    uint256 constant SALE_FOUR_BONUS_RATE = 5;
    
    uint256 constant BONUS_ONE_RATE = 0;
    
    //15 ETH in WEI
    uint256 constant BONUS_ONE_WEI = 15000000000000000000;
    // bonus 2% by the size of participation more than 15ETH
    uint256 constant BONUS_TWO_RATE = 2;
    
    // 70 ETH in WEI
    uint256 constant BONUS_TWO_WEI = 70000000000000000000;
    // bonus 5% by the size of participation more than 70ETH
    uint256 constant BONUS_THREE_RATE = 5;
    
    // 300 ETH in WEI
    uint256 constant BONUS_THREE_WEI = 300000000000000000000;
    // bonus 10% by the size of participation more than 300ETH
    uint256 constant BONUS_LARGE_RATE = 10;
}