pragma solidity ^0.8.16;

contract signature {
    function verify (address _signer, string memory _message, bytes memory _sig)
    external pure returns(bool) {
        bytes32 messageHash = getMessageHash(_message);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);
        return recover(ethSignedMessageHash, _sig)== _signer;

    }

    function getMessageHash(string memory _message) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_message));
    }

    function getEthSignedMessageHash(bytes32 _messageHash) public pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message: \n32",_messageHash));
    }

    function recover(bytes32 _ethSignedMessageHash, bytes memory _sig) public pure returns(address) {
        (bytes32 r, bytes32 s, uint8 v) = _split(_sig);
        ecrecover(_ethSignedMessageHash, v, r, s);
    }
    
    function _split(bytes memory _sig) internal pure returns(bytes32 r, bytes32 s, uint8 v) {
        require(_sig.length == 65, "invalid length");

        assembly {
            r := mload(add(_sig, 32))
            s := mload(add(_sig, 64))
            v := byte(0, mload(add(_sig, 96)))
        } //0xb52c5fb020c95d9f43a359e4de2430612c675923a457b2078c610d109e46f04f7438a633d79720a4e67a73282cebb2b47286c95169a1a75b4c917fd7a6d582191b
    }




}