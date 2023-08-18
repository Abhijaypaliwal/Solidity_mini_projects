pragma solidity ^0.5.16;
contract Token {

    /// @return total amount of tokens
    function totalSupply() public pure returns (uint256 supply) {}

    /// @param _owner The address from which the balance will be retrieved
    /// @return The balance
    function balanceOf(address _owner) public pure returns (uint256 balance) {}

    /// @notice send `_value` token to `_to` from `msg.sender`
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transfer(address _to, uint256 _value) public returns (bool success) {}

    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}

    /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @param _value The amount of wei to be approved for transfer
    /// @return Whether the approval was successful or not
    function approve(address _spender, uint256 _value) public returns (bool success) {}

    /// @param _owner The address of the account owning tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @return Amount of remaining tokens allowed to spent
    function allowance(address _owner, address _spender) public pure returns (uint256 remaining) {}

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    
}


contract mintingToken is Token{

    string name= "abhi";
    string symbol="ABH";
    uint256 supply= 1000000000000000000000000;
    address owner;
    uint8 public decimals = 18;
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    constructor() public {
        owner=msg.sender;
        balances[owner]= supply;
    }
    function allowance(address _owner, address _spender) pure public returns (uint256 remaining) {}
    
    function approve(address spender, uint amount) public returns(bool) {
        allowed[msg.sender][spender]= amount;
    }

    function transfer(uint256 amount, address reciever) public returns (bool){
        if(balances[msg.sender]>= amount && allowed[msg.sender][reciever]>= amount) {
        balances[msg.sender]-= amount;
        balances[reciever]+=amount;
        allowed[msg.sender][reciever]-= amount;
    }
    }

    function balance() public view returns(uint256) {
        return balances[msg.sender];
    }



    } 
    

