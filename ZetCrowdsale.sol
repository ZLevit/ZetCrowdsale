pragma solidity ^0.4.23;

import "./SafeMath.sol";
import "./CappedCrowdsale.sol";
import "./MintedCrowdsale.sol";
import "./TimedCrowdsale.sol";
import "./RefundableCrowdsale.sol";
import "./DateTime.sol";
import "./ZetCrowdsaleToken.sol";
import "./ZetCrowdsaleInfo.sol";



/**
 * @title BonusRefundableCrowdsale
 * @dev FinalizableCrowdsale with Bonus Support.
 */

contract BonusRefundableCrowdsale is CappedCrowdsale, 
                TimedCrowdsale, RefundableCrowdsale,
                MintedCrowdsale, ZetCrowsaleInfo {


        address public reservedFundsWallet ;

        // tokens delivered as bonus
        uint256 public deliveredBonusTokens;
        
        // tokens purchased during ICO
        uint256 public purchasedTokens;
        
        constructor( address _wallet, address _reservedFundsWallet,   ERC20 _token) public
        Crowdsale(TOKEN_RATE, _wallet, _token)
        CappedCrowdsale(WEI_HARD_CAP)
        TimedCrowdsale(OPENNING_DT, CLOSING_DT)
        RefundableCrowdsale(WEI_SOFT_CAP)
        { 
            require(_reservedFundsWallet != 0);
        
            deliveredBonusTokens = 0;
            purchasedTokens = 0;
            
            reservedFundsWallet = _reservedFundsWallet;
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
                // no volume bonuses
                if (isPresale())
                    return 0;
                    
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
          
          /**
           * @dev   PRE-SALE cap implemenetation AND Minimum WEI purchase Validation
           * @param _beneficiary Token purchaser
           * @param _weiAmount Amount of wei contributed
           */
          function _preValidatePurchase(
            address _beneficiary,
            uint256 _weiAmount
          )
            internal
          {
            super._preValidatePurchase(_beneficiary, _weiAmount);
            
            if (isPresale())
                require(weiRaised.add(_weiAmount) <= PRESALE_WEI_CAP);
                
             require(_weiAmount>= WEI_PURCHASE_MIN);
          }
          
          /**
           * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
           * @param _beneficiary Address receiving the tokens
           * @param _tokenAmount Number of tokens to be purchased
           */
          function _processPurchase(
            address _beneficiary,
            uint256 _tokenAmount
          )
            internal
            {
                super._processPurchase(_beneficiary, _tokenAmount);
                purchasedTokens = SafeMath.add(purchasedTokens, _tokenAmount);
            }
            
          /**
           * @dev while finalize - deliver tokens to team, etc.
           * should call super.finalization() to ensure the chain of finalization is
           * executed entirely.
           */
          function finalization() internal {
              super.finalization();
              finalDeliverBonusTokens();
          }
          
          
          /**
           * @dev while finalize - deliver team bonus tokens
           * Deliver some bonus tokens.
           */
          function deliverSomeBonusTokens(uint256 tokenAmount) onlyOwner public    {
              if (SafeMath.add(deliveredBonusTokens, tokenAmount) > TOKEN_BONUS_FINALIZE)  
              {
                tokenAmount =   SafeMath.sub(TOKEN_BONUS_FINALIZE, deliveredBonusTokens);     
              }
              
              _deliverTokens(reservedFundsWallet, tokenAmount);       
              deliveredBonusTokens = SafeMath.add(deliveredBonusTokens, tokenAmount);
          }
                
           /**
           * @dev while finalize - deliver team bonus tokens
           * should call super.finalization() to ensure the chain of finalization is
           * executed entirely.
           */
          function finalDeliverBonusTokens() onlyOwner public    {
              if (deliveredBonusTokens >= TOKEN_BONUS_FINALIZE)  
                return;
              
              uint256 tokenAmount = SafeMath.sub(TOKEN_BONUS_FINALIZE, deliveredBonusTokens);
              
              _deliverTokens(reservedFundsWallet, tokenAmount);       
              
              deliveredBonusTokens = SafeMath.add(deliveredBonusTokens, tokenAmount);
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
        dbgPeriodValue = DBG_DISABLE;
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
    
     function dbgStartSaleFour() public  {
        dbgPeriodValue = DBG_SALE_4_PERIOD_VALUE;
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

   constructor(address _wallet, address _reservedFundsWallet, ERC20 _token) public  
    BonusRefundableCrowdsale(_wallet, _reservedFundsWallet, _token)
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
     DbgBonusRefundableCrowdsale  {

  constructor(
    address _wallet, address _reservedFundsWallet
  )
  public 
    DbgBonusRefundableCrowdsale(_wallet, _reservedFundsWallet, new ZetCrowdsaleToken())    
    {
    }
}
