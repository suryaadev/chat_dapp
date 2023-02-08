import {ethers} from "ethers"
import modal from "web3modal"
import { ChatDappAddress, ChatDappABI } from "../Context/constants"

export const CheckIfWalletConnected = async () => {
  try {
    if (!window.ethereum) return alert("Install Metamask")

    const accounts = await window.ethereum.request({
      method: "eth_requestAccounts",
    })

    const firstAccount = accounts[0]
  } catch (error) {
    console.error(error)
  }
}

export const connectWallet = async ()=>{
    try {
        if (!window.ethereum) return alert("Install Metamask")
    
        const accounts = await window.ethereum.request({
          method: "eth_requestAccounts",
        })
    
        const firstAccount = accounts[0]
        return firstAccount
      } catch (error) {
        console.error(error)
      }
}

const fetchContract = (signerOrProvider) => new ethers.Contract(ChatDappAddress,ChatDappABI,signerOrProvider)

export const connectingWithContract = async() =>{
    try {
        
    } catch (error) {
        console.error(error);
    }
}
