//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {Base64} from "../libraries/Base64.sol";

contract NFTEpic is ERC721URIStorage, VRFConsumerBase {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    bytes32 internal keyHash;
    uint256 internal fee;

    uint256 public randomResult;
    uint256[3] public nums;

    mapping(bytes32 => address) public toAddresses;

    event RandomGenerated(address indexed to, uint256 value);
    event NFTMinted(address indexed minter, uint256 indexed tokenNum);

    uint256 private totalNumberOfTokens = 0;

    string baseSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = [
        "Eren",
        "Armin",
        "Mikasa",
        "Annie",
        "Historia",
        "Jean",
        "Hange",
        "Levi",
        "Erwin",
        "Reiner",
        "Sasha",
        "Bertholdt",
        "Connie",
        "Zeke"
    ];
    string[] secondWords = [
        "Yeager",
        "Arlert",
        "Ackerman",
        "Braus",
        "Springer",
        "Kirschtein",
        "Smith",
        "Ackerman",
        "Zoe",
        "Braun",
        "Leonhart",
        "Hoover",
        "Reiss",
        "Yeager"
    ];
    string[] thirdWords = [
        "Kills",
        "Explores",
        "Cares",
        "Eats",
        "Dies",
        "Farts",
        "IsAHorse",
        "Strategizes",
        "IsShort",
        "IsCreepy",
        "IsDepressed",
        "Sleeps",
        "IsEaten",
        "Queen",
        "Monke"
    ];

    constructor()
        ERC721("EldiaMarleyNFT", "ElMarNFT")
        VRFConsumerBase(
            0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B, // VRF Coordinator
            0x01BE23585060835E02B77ef475b0Cc51aA1e0709 // LINK Token
        )
    {
        keyHash = 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311;
        fee = 0.1 * 10**18; // 0.1 LINK (Varies by network)
    }

    function getRandomNumber() public returns (bytes32) {
        IERC20(0x01BE23585060835E02B77ef475b0Cc51aA1e0709).transferFrom(
            msg.sender,
            address(this),
            0.1 * 10**18
        );
        require(
            LINK.balanceOf(address(this)) >= fee,
            "Not enough LINK - fill contract with faucet"
        );

        bytes32 requestId = requestRandomness(keyHash, fee);
        toAddresses[requestId] = msg.sender;

        return requestId;
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomness)
        internal
        override
    {
        randomResult = randomness;
        expand(randomness, 3);
        emit RandomGenerated(toAddresses[requestId], randomness);
    }

    function expand(uint256 randomValue, uint256 n) public {
        for (uint256 i = 0; i < n; i++) {
            nums[i] = uint256(keccak256(abi.encode(randomValue, i)));
        }
    }

    function pickRandomFirstWord() public view returns (string memory) {
        uint256 rand = nums[0];
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord() public view returns (string memory) {
        uint256 rand = nums[1];
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord() public view returns (string memory) {
        uint256 rand = nums[2];
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function makeAnEpicNFT() public {
        require(
            _tokenIds.current() < 100,
            "Only a hundred tokens can be minted"
        );
        uint256 newItemId = _tokenIds.current();

        string memory first = pickRandomFirstWord();
        string memory second = pickRandomSecondWord();
        string memory third = pickRandomThirdWord();
        string memory combinedWord = string(
            abi.encodePacked(first, second, third)
        );

        string memory finalSvg = string(
            abi.encodePacked(baseSvg, combinedWord, "</text></svg>")
        );

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        combinedWord,
                        '", "description": "A highly acclaimed collection of AOT characters", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        _safeMint(msg.sender, newItemId);

        _setTokenURI(newItemId, finalTokenUri);

        totalNumberOfTokens += 1;
        _tokenIds.increment();

        emit NFTMinted(msg.sender, newItemId);
    }

    function totalTokens() public view returns (uint256) {
        return totalNumberOfTokens;
    }
}
