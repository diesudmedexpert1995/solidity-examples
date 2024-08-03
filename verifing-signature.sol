// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
contract VerifySignature {

    function getMessageHash(string memory message_) public pure returns (bytes32){
        return keccak256(abi.encodePacked(message_));
    }

    function getEthSignedMessageHash(bytes32 messageHash_) public pure returns(bytes32){
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", messageHash_));
    }

    function verify(address signer_, address to_, string memory message_, uint amount_, uint256 nonce_, bytes memory signature_) public pure returns (bool){
        bytes32 _messageHash = getMessageHash(message_);
        bytes32 _ethSignedMessageHash = getEthSignedMessageHash(_messageHash);
        return recoverSigner(_ethSignedMessageHash, signature_) == signer_;
    }

    function recoverSigner(bytes32 ethSignedMessageHash_, bytes memory signature_) public pure returns(address) {
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(signature_);
        return ecrecover(ethSignedMessageHash_, v, r, s);
    }

    function splitSignature(bytes memory sig_) public pure returns(bytes32 r, bytes32 s, uint8 v){
        require(sig_.length == 65, "invalid signature length");
        assembly {
            r:=mload(add(sig_, 32))
            s:=mload(add(sig_, 64))
            v:=byte(0, mload(add(sig_, 96)))
        }
    }

}