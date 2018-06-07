pragma solidity ^0.4.23;

import "./SafeMath.sol";
import "./CappedCrowdsale.sol";
import "./MintedCrowdsale.sol";
import "./TimedCrowdsale.sol";
import "./RefundableCrowdsale.sol";
import "./MintableToken.sol";
import "./DateTime.sol";


/**
 * @title ZCrowdsaleToken
 * @dev Very simple ERC20 Token that can be minted.
 * It is meant to be used in a crowdsale contract.
 */
contract ZetCrowdsaleToken is MintableToken {

  // solium-disable-next-line uppercase
  string public constant name = "ZL Crowdsale Token";
  string public constant symbol = "ZLCT"; // solium-disable-line uppercase
  uint8 public constant decimals = 18; // solium-disable-line uppercase

}

contract ZetCrowsaleInfo
{
    // Openning sale date 
    // converted using https://www.epochconverter.com/ 
    uint256 constant OPENNING_DT =1526774400;
    
    // Closing sale date 
    // converted using https://www.epochconverter.com/ 
    uint256 constant CLOSING_DT =1535760000;
    
    // Rate 1 WEI  - 1000
    uint256 constant TOKEN_RATE = 1000;
    
    //   CAP -  maximum amount of wei accepted in the crowdsale. 
    //  use https://etherconverter.online/ to convert
    uint256 constant WEI_CAP =    1000000000000000000;

   //   CAP -  maximum amount of wei accepted in the crowdsale. 
   //  use https://etherconverter.online/ to convert
    uint256 constant WEI_GOAL =    700000000000000000;
    
    // WEI - minimum ammount for purchase
    // 0.02 Ether.
    uint256 constant WEI_PURCHASE_MIN =    20000000000000000;
    
    
    /*    maximum amount of wei accepted in the pre-sale. */    
    //  use https://etherconverter.online/ to convert
    uint256 constant PRESALE_WEI_CAP    = 100000000000000;
    uint256 constant PRESALE_ONE_BONUS_RATE = 50;
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

/**
 * @title BonusRefundableCrowdsale
 * @dev FinalizableCrowdsale with Bonus Support.
 */

contract BonusRefundableCrowdsale is  TimedCrowdsale, /*RefundableCrowdsale,*/ ZetCrowsaleInfo {

        constructor(uint256 _openingTime, uint256 _closingTime, uint256 _goal) public 
        TimedCrowdsale(_openingTime, _closingTime)
        //RefundableCrowdsale(_goal)
        {   
        }
        
        // @dev Checks if current period is presale period 
        // @return true if current period is pre sale.
        function isPresale() internal constant returns (bool) {
             return now <= PRESALE_CLOSING_DT;
        }
        
        // @dev Checks if current period is Sale One period 
        // @return true if current period is pre sale.
        function isSaleOne() internal constant returns (bool) {
            return  (now > PRESALE_CLOSING_DT && now <= SALE_ONE_CLOSING_DT);
        }
  
        // @dev Checks if current period is Sale Two period 
        // @return true if current period is pre sale.
        function isSaleTwo() internal constant returns (bool) {
            return  (now > SALE_ONE_CLOSING_DT && now <= SALE_TWO_CLOSING_DT);
        }
  
       // @dev Checks if current period is Sale Three period 
       // @return true if current period is pre sale.
        function isSaleThree() internal constant returns (bool) {
            return  (now > SALE_TWO_CLOSING_DT && now <= SALE_THREE_CLOSING_DT);
        }
        
        // @dev Checks if current period is Sale Four period 
        // @return true if current period is pre sale.
        function isSaleFour() internal constant returns (bool) {
            return  (now > SALE_THREE_CLOSING_DT && now <= SALE_FOUR_CLOSING_DT);
        }

        /**
        * @dev Sale program implemenetation.
        * @return bonuse persentage
        */
        function calcSalePeriodPersentage() internal view returns (uint256)
          {
            uint256 persentage = 0;
            
            if (isPresale())
            {
                persentage =  PRESALE_ONE_BONUS_RATE;
            }
            else if (isSaleOne())
            {
                persentage =  SALE_ONE_BONUS_RATE;
            }
            else if (isSaleTwo())
            {
                persentage = SALE_TWO_BONUS_RATE;
            }
            else if (isSaleThree())
            {
                persentage = SALE_THREE_BONUS_RATE;
            }
            else if (isSaleFour())
            {
                persentage = SALE_FOUR_BONUS_RATE;
            } 
            
            
            return persentage;
          }
          
          /**
           * @dev Volume Bonus program implemenetation.
           * @param _weiAmount Value in wei 
           * @return Bonus persentage
           */
            function calcBonusPersentage(uint256 _weiAmount) internal returns (uint256)
            {
                if (_weiAmount < BONUS_ONE_WEI)
                  return BONUS_ONE_RATE;
                else if (_weiAmount < BONUS_TWO_WEI)
                  return BONUS_TWO_RATE;
                 else if  (_weiAmount < BONUS_THREE_WEI)
                  return BONUS_THREE_RATE;
                  
                // _weiAmount is higher than BONUS_THREE_WEI 
                return BONUS_LARGE_RATE;
            }
            
            
   /**
   * 
   * @dev Token conversion.  
   * @param _weiAmount Value in wei to be converted into tokens
   * @return Number of tokens that can be purchased with the specified _weiAmount
   */
  function _getTokenAmount(uint256 _weiAmount)
    internal view returns (uint256)
  {
    uint256 salePersentage = calcSalePeriodPersentage();
    uint256 bonusPersentage = calcBonusPersentage(_weiAmount);
    uint256 accumPersentage  = SafeMath.add(salePersentage, bonusPersentage);
    accumPersentage = SafeMath.add(100, accumPersentage);
    
    uint256 tokenAmount = super._getTokenAmount(_weiAmount);
    if (accumPersentage == 100)
      return tokenAmount;
        
    tokenAmount = SafeMath.div(tokenAmount, 100);
    tokenAmount = SafeMath.mul(tokenAmount, accumPersentage);
    
    return tokenAmount;
  }

}

contract DbgHelper {
    
    uint8 constant DBG_PRESALE_PERIOD_VALUE = 0;
    uint8 constant DBG_SALE_1_PERIOD_VALUE = 1;
    uint8 constant DBG_SALE_2_PERIOD_VALUE = 2;
    uint8 constant DBG_SALE_3_PERIOD_VALUE = 3;
    uint8 constant DBG_SALE_4_PERIOD_VALUE = 4;
    uint8 constant DBG_CROWDSALE_PERIOD_VALUE = 5;
    uint8 constant DBG_CLOSED_SALE_PERIOD_VALUE = 128;
    
    uint8 constant DBG_DISABLE = 254;
    
    uint8 dbgPeriodValue;
    
    constructor () public
    {
        dbgPeriodValue = DBG_PRESALE_PERIOD_VALUE;
    }

    function dbgStartPresale() public      {
        dbgPeriodValue = DBG_PRESALE_PERIOD_VALUE;
    }
    
    function dbgStartSaleOne() public      {
        dbgPeriodValue = DBG_SALE_1_PERIOD_VALUE;
    }
    
    function dbgStartSaleTwo() public  {
        dbgPeriodValue = DBG_SALE_2_PERIOD_VALUE;
    }
    
    function dbgStartSaleThree() public  {
        dbgPeriodValue = DBG_SALE_3_PERIOD_VALUE;
    }
    
     function dbgStartCrowdsale() public  {
        dbgPeriodValue = DBG_CROWDSALE_PERIOD_VALUE;
    }
    
    
    function dbgCloseSale() public       {
        dbgPeriodValue = DBG_CLOSED_SALE_PERIOD_VALUE;
    }
    
    function dbgDisabled() public  {
        dbgPeriodValue = DBG_DISABLE;
    }
    
    
    function isDbgClosedSale() public view returns (bool)     {
        return dbgPeriodValue == DBG_CLOSED_SALE_PERIOD_VALUE;
    }
    
    
    function isDbgPresale() public view returns (bool)     {
        return dbgPeriodValue == DBG_PRESALE_PERIOD_VALUE;
    }
    
    function isDbgSaleOne() public view returns (bool)     {
        return dbgPeriodValue == DBG_SALE_1_PERIOD_VALUE;
    }
    
    function isDbgSaleTwo() public view returns (bool)     {
        return dbgPeriodValue == DBG_SALE_2_PERIOD_VALUE;
    }
    
    function isDbgSaleThree() public view returns (bool)     {
        return dbgPeriodValue == DBG_SALE_3_PERIOD_VALUE;
    }
    
    function isDbgSaleFour() public view returns (bool)     {
        return dbgPeriodValue == DBG_SALE_4_PERIOD_VALUE;
    }
    
    
    function isDbgCrowdsale() public view returns (bool)     {
        return dbgPeriodValue == DBG_CROWDSALE_PERIOD_VALUE;
    }
    
    function isDbgSaleOpened() public view returns (bool)
    {
        return (( DBG_PRESALE_PERIOD_VALUE <= dbgPeriodValue) && (dbgPeriodValue <= DBG_CROWDSALE_PERIOD_VALUE));
    }
    
    function isDbgEnabled() public view returns (bool)     {
        return dbgPeriodValue != DBG_DISABLE;
    }
    
    function isDbgDisabled() public  view returns (bool)     {
        return dbgPeriodValue == DBG_DISABLE;
    }
    
}

contract DbgBonusRefundableCrowdsale is BonusRefundableCrowdsale, DbgHelper {

   constructor(uint256 _openingTime, uint256 _closingTime, uint256 _goal) public  
    BonusRefundableCrowdsale(_openingTime, _closingTime, _goal)
    DbgHelper()
    {   
    }
    
    function onlyWhileOpen() internal   {
        
     if (isDbgEnabled())
     {
       require(isDbgSaleOpened());
       return;
     }
    
      super.onlyWhileOpen();
    }

    /**
   * @dev Checks whether the period in which the crowdsale is open has already elapsed.
   * @return Whether crowdsale period has elapsed
   */
    function hasClosed() public view returns (bool) {
    
      if (isDbgEnabled())
        return isDbgClosedSale();
    
      return super.hasClosed();
    }

    
    // @dev Checks if current period is presale period 
    // @return true if current period is pre sale.
    function isPresale() internal constant returns (bool) {
        if (isDbgEnabled())
         return isDbgPresale();
        
        return super.isPresale();
    }
  
      // @dev Checks if current period is Sale One period 
      // @return true if current period is pre sale.
      function isSaleOne() internal constant returns (bool) {
         if (isDbgEnabled())
            return isDbgSaleOne();
         return super.isSaleOne();
      }
  
  // @dev Checks if current period is Sale Two period 
  // @return true if current period is pre sale.
  function isSaleTwo() internal constant returns (bool) {
    if (isDbgEnabled())
        return isDbgSaleTwo();
    
    return super.isSaleTwo();
  }
  
  // @dev Checks if current period is Sale Three period 
  // @return true if current period is pre sale.
  function isSaleThree() internal constant returns (bool) {
      if (isDbgEnabled())
        return isDbgSaleThree();
      return super.isSaleThree();
  }
  
  // @dev Checks if current period is Sale Four period 
  // @return true if current period is pre sale.
  function isSaleFour() internal constant returns (bool) {
      if (isDbgEnabled())
          return isDbgSaleFour();
      return super.isSaleFour();
  }
}


contract ZetCrowdsale is 
     CappedCrowdsale, DbgBonusRefundableCrowdsale, MintedCrowdsale  {

  constructor(
    address _wallet
  )
  public 
    Crowdsale(TOKEN_RATE, _wallet, new ZetCrowdsaleToken())
    CappedCrowdsale(WEI_CAP)
    DbgBonusRefundableCrowdsale(OPENNING_DT, CLOSING_DT, WEI_GOAL)    
    {
    }
    
     /**
   * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
   * @param _beneficiary Address performing the token purchase
   * @param _weiAmount Value in wei involved in the purchase
   */
  function _preValidatePurchase(
    address _beneficiary,
    uint256 _weiAmount
  ) internal
  {
      super._preValidatePurchase(_beneficiary, _weiAmount);
      require(_weiAmount>= WEI_PURCHASE_MIN);
  }
}
