pragma solidity ^0.8.16;

contract Kata {
  function maxMultiple(int d, int b) public pure returns (int) {
    int num = 1;
    int temp1 = 1;
    int temp2 = 1;
    for (int i = 1; i<=num; i++)
    {
      if(temp2 <= b) {
        
      temp1 = (num) *d;
      temp2 = (num+1) *d;
       
      num++;
      }
      else {
        return temp1;
      }
    }

  }
}