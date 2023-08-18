pragma solidity ^0.8.16;

interface ERC20 {

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    function name() external view   returns (string memory);

    function approve(address spender, uint256 amount) external returns (bool) ;

}

contract tokenSwap {

    uint public token0;
    uint public token1;

    struct poolDetails {
        address token0;
        uint poolAmt0;
        address token1;
        uint poolAmt1;
        uint poolRatio;
    }

    mapping(uint => poolDetails) public poolMapping;
    uint public poolNum = 0;
    poolDetails detailsOfPool;

    function swapToken(address _tokenToSwap, address _tokenSwapped, uint _amount, uint _poolNum) public {
        ERC20 tokenContract0 = ERC20(_tokenToSwap);
        ERC20 tokenContract1 = ERC20(_tokenSwapped);
        tokenContract0.transferFrom(msg.sender, address(this), _amount);
        uint tokenSwappedAmt = _amount / poolMapping[_poolNum].poolRatio ;
        tokenContract1.transferFrom( address(this),msg.sender, tokenSwappedAmt);
    
    }

    function poolInitialize(address _token0, uint _amt0, address _token1, uint _amt1) public {
        ERC20 tokenContract0 = ERC20(_token0);
        ERC20 tokenContract1 = ERC20(_token1);
        tokenContract0.transferFrom(msg.sender, address(this), _amt0); 
        tokenContract1.transferFrom(msg.sender, address(this), _amt1); 
        poolNum++;
        uint poolRatio = _amt0 / _amt1;
        detailsOfPool = poolDetails(_token0, _amt0, _token1, _amt1, poolRatio);
        poolMapping[poolNum] = detailsOfPool;
    }

    function addLiquidity(address _token0, address _token1, uint _tokenAmt0, uint _poolNum) public {
        ERC20 tokenContract0 = ERC20(_token0);
        ERC20 tokenContract1 = ERC20(_token1);
        uint _poolRatio = poolMapping[_poolNum].poolRatio;
        uint token1AmtAfterPoolRatio = _tokenAmt0 / _poolRatio;
        tokenContract0.transferFrom(msg.sender, address(this), _tokenAmt0); 
        tokenContract1.transferFrom(msg.sender, address(this), token1AmtAfterPoolRatio); 
        poolMapping[_poolNum].poolAmt0 += _tokenAmt0;
        poolMapping[_poolNum].poolAmt1 += token1AmtAfterPoolRatio;
    }
}