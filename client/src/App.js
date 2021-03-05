// import logo from './logo.svg';
// import './App.css';

// function App() {
//   return (
//     <div className="App">
//       <header className="App-header">
//         <img src={logo} className="App-logo" alt="logo" />
//         <p>
//           Edit <code>src/App.js</code> and save to reload.
//         </p>
//         <a
//           className="App-link"
//           href="https://reactjs.org"
//           target="_blank"
//           rel="noopener noreferrer"
//         >
//           Learn React
//         </a>
//       </header>
//     </div>
//   );
// }

// export default App;

import React from 'react';
import {BrowserRouter as Router, Route, NavLink, Switch} from 'react-router-dom';
import './App.css';
import Home from './components/pages/Home';
import ArticleList from './components/articles/ArticleList';
import ArticleInfo from './components/articles/ArticleInfo';
import ArticleAdd from './components/articles/ArticleAdd';
import ArticleEdit from './components/articles/ArticleEdit';

function App() {
  return (
    <div className="App">     
      <Router>
        <Navigation />
        <div className="container">
          <Main />
        </div>
      </Router>
    </div>
  );
}

function Navigation() {
  return(
    <nav className="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
      <div className='container'>
        <ul className="navbar-nav mr-auto">
          <li className="nav-item"><NavLink exact className="nav-link" activeClassName="active" to="/">Home</NavLink></li>
          <li className="nav-item"><NavLink exact className="nav-link" activeClassName="active" to="/articles">Articles</NavLink></li>
        </ul>
      </div>
    </nav>
  );
}

function Main() {
  return(
    <Switch>
      <Route exact path="/" component={Home} />
      <Route exact path="/articles" component={ArticleList} />
      <Route exact path="/articles/new" component={ArticleAdd} />
      <Route exact path="/articles/:_id" component={ArticleInfo} />
      <Route exact path="/articles/:_id/edit" component={ArticleEdit} />
    </Switch>
  );
}

export default App;
