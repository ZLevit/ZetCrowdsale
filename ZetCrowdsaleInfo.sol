pragma solidity ^0.4.23;


/**
 * @title ZCrowdsaleToken
 * @dev Very simple ERC20 Token that can be minted.
 * It is meant to be used in a crowdsale contract.
 */
contract ZetCrowsaleInfo
{
    // Openning sale date 
    // converted using https://www.epochconverter.com/ 
    uint256 constant OPENNING_DT =1526774400;
    
    // Closing sale date 
    // converted using https://www.epochconverter.com/ 
    uint256 constant CLOSING_DT =1535760000;
    
    // Rate 1 WEI  - 6000
    uint256 constant TOKEN_RATE = 6000;
    
    //   HARD CAP -  maximum amount of wei accepted in the crowdsale. 
    //  use https://etherconverter.online/ to convert
    uint256 constant WEI_HARD_CAP =     70000000000000000000;

   //   SOFT CAP -  maximum amount of wei accepted in the crowdsale. 
   //  use https://etherconverter.online/ to convert
    uint256 constant WEI_SOFT_CAP =     10000000000000000000;
    
    // WEI - minimum ammount for purchase
    // 0.02 Ether.
    uint256 constant WEI_PURCHASE_MIN = 20000000000000000;
    
    // TOKEN_BONUS_FINALIZE - ammount allocated to team in token
    // 100, 000 
    uint256 constant TOKEN_BONUS_FINALIZE = 100000000000000000000000;
    
    /*    maximum amount of wei accepted in the pre-sale. */    
    //  use https://etherconverter.online/ to convert
    uint256 constant PRESALE_WEI_CAP    = 163952988410350003200;
    uint256 constant PRESALE_ONE_BONUS_RATE = 100;
    /* converted using https://www.epochconverter.com/ 1-Sep-2018*/
    uint256 constant PRESALE_CLOSING_DT =1535760000;

    /* converted using https://www.epochconverter.com/ 1-Sep-2018*/
    uint256 constant SALE_ONE_CLOSING_DT = 1535760000;
    uint256 constant SALE_ONE_BONUS_RATE = 20;
    
    /* converted using https://www.epochconverter.com/ 1-Sep-2018*/
    uint256 constant SALE_TWO_CLOSING_DT =1535760000;
    uint256 constant SALE_TWO_BONUS_RATE = 15;
    
    /* converted using https://www.epochconverter.com/ 1-Sep-2018*/
    uint256 constant SALE_THREE_CLOSING_DT =1535760000;
    uint256 constant SALE_THREE_BONUS_RATE = 10;
    
    /* converted using https://www.epochconverter.com/ 1-Sep-2018*/
    uint256 constant SALE_FOUR_CLOSING_DT =1535760000;
    uint256 constant SALE_FOUR_BONUS_RATE = 5;
    
    
    uint256 constant BONUS_ONE_RATE = 0;
    //15  Ether
    uint256 constant BONUS_ONE_WEI  = 15000000000000000000;
    
    uint256 constant BONUS_TWO_RATE = 2;
    // 70 Ether
    uint256 constant BONUS_TWO_WEI = 70000000000000000000;
    
    uint256 constant BONUS_THREE_RATE = 5;
    // 300 Ether
    uint256 constant BONUS_THREE_WEI = 300000000000000000000;
    
    uint256 constant BONUS_LARGE_RATE = 10;
}
