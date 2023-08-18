pragma solidity ^0.8.16;

contract roman {

    
    function fetchDigit(uint256 number, uint256 position) public pure returns (uint256) {
        uint256 divisor = 10**position;
        uint256 digit = (number / divisor) % 10;
        
        return digit;
    }

    function getRoman(uint _num) public pure returns (string memory) {
        uint number = _num;
        uint temp = 3;
        string memory romanRepr;

    while (number != 0) {
    //uint num1 = number % (10 ** temp);
    if (number > 1000) {
        uint num1 = fetchDigit(number, 3);
        for (uint i = 0; i < num1 ; i++) {
            romanRepr = string(abi.encodePacked(romanRepr, "M"));
        }
        number = number % 1000;
    }
    
    if (number >= 100 && number < 1000) {
            if (number >= 500) {
                //uint temp1 = number;
                romanRepr = string(abi.encodePacked(romanRepr, "D"));
                uint temp1 =  fetchDigit(number-500, 2);
                for (uint i = 0; i < temp1 ; i++) {
                    romanRepr = string(abi.encodePacked(romanRepr, "C"));
                }
                //number = num1-1;
                number = number % 100;
            }
            if (number >= 100 && number < 500) {
                uint temp1 =  fetchDigit(number, 2);
                for (uint i = 0; i < temp1 ; i++) {
                    romanRepr = string(abi.encodePacked(romanRepr, "D"));
                }
                //number = num1-1;
                number = number % 100;
            }
    }

            
    if (number >= 50) {
                    //uint temp1 = number;
                    romanRepr = string(abi.encodePacked(romanRepr, "L"));
                    uint temp1 =  fetchDigit(number-50, 1);
                    for (uint i = 0; i < temp1 ; i++) {
                        romanRepr = string(abi.encodePacked(romanRepr, "X"));
                    }
                    //number = num1-1;
                    number = number % 10;
                }
    if (number >= 10 && number < 50) {
                    uint temp1 =  fetchDigit(number, 1);
                    for (uint i = 0; i < temp1 ; i++) {
                        romanRepr = string(abi.encodePacked(romanRepr, "X"));
                    }
                    //number = num1-1;
                    number = number % 10;
                }
                
                    if (number >= 5) {
                        //uint temp1 = number;
                        romanRepr = string(abi.encodePacked(romanRepr, "V"));
                        uint temp1 =  fetchDigit(number-5, 0);
                        for (uint i = 0; i < temp1 ; i++) {
                            romanRepr = string(abi.encodePacked(romanRepr, "I"));
                        }
                        //number = num1-1;
                        number = 0;
                    }
                    if (number >= 1 && number < 5) {
                        uint temp1 =  fetchDigit(number, 0);
                        for (uint i = 0; i < temp1 ; i++) {
                            romanRepr = string(abi.encodePacked(romanRepr, "I"));
                        }
                        //number = num1-1;
                        number = 0;
                    }

                
            
        
        

    }
    return romanRepr;
}
    
    

    function appendString(string memory _a, string memory _b, string memory _c) public pure returns (string memory)  {
    return string(abi.encodePacked(_a, _b, _c));
}
}