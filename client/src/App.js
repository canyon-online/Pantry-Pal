// react routing tutorial: https://reactrouter.com/web/guides/philosophy

// To create a component we need to import the React library.
import React from 'react';

// Import the components you need from the react-router-dom module. React Router
// also has a react-router-native module for mobile apps. In this case we'll import 
// the BrowserRouter (giving it an alias of Router), Route, NavLink, and Switch components.
import {BrowserRouter as Router, Route, NavLink, Switch} from 'react-router-dom';

// Import the Bootstrap CSS library we added.
import "bootstrap/dist/css/bootstrap.min.css"; // from node_modules

// Import the other components that we will be calling with our Routes.
// Each of those files will contain a functional component.
import './App.css';
import Home from './components/pages/Home';
import ArticleList from './components/articles/ArticleList';
import ArticleInfo from './components/articles/ArticleInfo';
import ArticleAdd from './components/articles/ArticleAdd';
import ArticleEdit from './components/articles/ArticleEdit';

function App() {
  return (
    <div className="App">
        {/* In the App function's return statement we appended the <Router>
            element to manage our routing. It contains two custom elements:
          */}
        <Router>
            {/* <Navigation /> and <Main /> are custom elements that call the corresponding components. 
                Nothing special about those names, you could call them what you like. 
                Those components return JSX that gets inserted into the App component. 
              */}
            <Navigation />
                <div className="container">
                    <Main />
                </div>
        </Router>
    </div>
    );
}

// The Navigation component returns JSX that ultimately renders the nav bar using the Bootstrap classes we provide here.
function Navigation() {
    return(
        <nav className="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
        <div className='container'>
            <ul className="navbar-nav mr-auto">
                {/* The React Router NavLink component is a subset of a Link component that we'll use shortly.
                    It provides the activeClassName property to style the link differently when it's active.
                    The other thing to note is the "exact" attribute, which is the shorthand for "exact=true." 
                    That means the route has to be the exact route provided with the "to" attribute. 
                    The default is that it just contains the route provided. So the "/" route by default would
                    include any route that contains "/", which is all routes. So we need the exact attibute here.
                  */}
                <li className="nav-item"><NavLink exact className="nav-link" activeClassName="active" to="/">Home</NavLink></li>
                <li className="nav-item"><NavLink exact className="nav-link" activeClassName="active" to="/articles">Articles</NavLink></li>
            </ul>
        </div>
        </nav>
    );
}

// The Main component is where we insert all our Route elements.
function Main() {
    return(
        <Switch>
            {/* The React Router switch statement works like a JavaScript switch statement. 
                It checks each statement below it in order until there is a match.
              */}
            <Route exact path="/" component={Home} />
            {/* Route is a React Router element that takes as attributes the path
                and the component to call if there is a match. The "exact" attribute
                requires the match be exact.
              */}
            <Route exact path="/articles" component={ArticleList} />
            <Route exact path="/articles/new" component={ArticleAdd} />
            <Route exact path="/articles/:_id" component={ArticleInfo} />
            <Route exact path="/articles/:_id/edit" component={ArticleEdit} />
        </Switch>
    );
}

export default App;
