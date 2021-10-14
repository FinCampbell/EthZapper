pragma solidity ^0.8.0;

import "./@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./interfaces/IPair.sol";
import "./interfaces/IRouter.sol";
import "./interfaces/IWETH.sol";


contract ETHZapper {
    IPair lpToken;
    IWETH token1; //WETH
    IERC20 token0; //SPELL
    IRouter router;
    uint256 amount;
    uint amountOutTest;

    uint constant private BIPS_DIVISOR = 10000;

    constructor() {
        lpToken = IPair(0xb5De0C3753b6E1B4dBA616Db82767F17513E6d4E); //SPELL-WETH SLP
        router = IRouter(0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F); //SushiSwap Router V2

        address _token1 = lpToken.token1();
        address _token0 = lpToken.token0();
        token1 = IWETH(_token1);
        token0 = IERC20(_token0);
        _setAllowances();
    }

    function  _setAllowances() internal  {
        token0.approve(address(router), token0.totalSupply());
        token1.approve(address(router), token1.totalSupply());
    }

    function zap() payable public {
        require(msg.value > BIPS_DIVISOR, "invalid zap amount");
        _depositToWETH();
        amount = token1.balanceOf(address(this)) / 2;
        _swapToUSDC(amount);

        (,,uint liquidity) = router.addLiquidity(
          address(token0), address(token1),
          token0.balanceOf(address(this)), token1.balanceOf(address(this)),
          0, 0,
          address(this),
          block.timestamp
        );
        
        lpToken.transfer(msg.sender, liquidity);
    }

     function _depositToWETH() internal {
        token1.deposit{value : msg.value}();
    }

    function _swapToUSDC(uint256 amountIn) internal returns(uint256){
        address[] memory path0 = new address[](2);
        path0[0] = address(token1);
        path0[1] = address(token0);

        uint amountOutToken0 = amountIn;
        uint[] memory amountsOutToken0 = router.getAmountsOut(amountIn, path0);
        amountOutToken0 = amountsOutToken0[amountsOutToken0.length - 1];
        router.swapExactTokensForTokens(amountIn, amountOutToken0, path0, address(this), block.timestamp);

        return amountOutToken0;
    }
    
}