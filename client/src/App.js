import React from 'react';
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import RoboscoutQueryListIndex from './components/RoboscoutQueryListIndex';
import RoboscoutQueryDetail from './components/RoboscoutQueryDetail'; // Assuming you have this component for detail view

const queryClient = new QueryClient();

function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <Router>
        <div>
          <Switch>
            <Route path="/roboscout_queries/:id" component={RoboscoutQueryDetail} />
            <Route path="/" component={RoboscoutQueryListIndex} />
          </Switch>
        </div>
      </Router>
    </QueryClientProvider>
  );
}

export default App;
