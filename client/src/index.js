// We import the React and ReactDOM libraries, and the App.jsx file (containing the App component).
import React from 'react';
import ReactDOM from 'react-dom';
import 'bootstrap/dist/css/bootstrap.css'
import './index.css';
import App from './App';
import reportWebVitals from './reportWebVitals';
// import Home from './components/pages/Home';

// The ReactDOM module's render method is what renders your React components to
// the public/index.html page. It takes two arguments. The first calls our component
// which is a custom React element called "App", or whatever name you want to give it.
// The second argument is the target element where we will render the output from <App />.
//  In this case the element with the id of "root".
ReactDOM.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
  document.getElementById('root')
);

// ReactDOM.render(<Home />, document.getElementById('root'));

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
