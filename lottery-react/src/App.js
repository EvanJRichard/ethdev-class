import React, { Component } from "react";
import logo from "./logo.svg";
import "./App.css";
import web3 from "./web3";
import lottery from "./lottery";

class App extends Component {
  constructor(props) {
    super(props);

    this.state = { manager: "" };
  }
  async componentDidMount() {
    //do not have to specify a 'from' for `call` because we are using metamask - evan
    const manager = await lottery.methods.manager().call();
    this.setState({ manager });
  }
  render() {
    return (
      <div>
        <h2> Lottery Contract</h2>
        <p>This contract is managed by {this.state.manager}</p>
      </div>
    );
  }
}

export default App;
