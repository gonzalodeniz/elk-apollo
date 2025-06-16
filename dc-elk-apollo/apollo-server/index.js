import apm from 'elastic-apm-node';

// ---------- 0. Configuración de APM ----------
apm.start({
  serviceName: 'apollo-server',
  serverUrl: 'http://apm-server:8200',
  secretToken: 'secretoAPM',  
  environment: 'produccion',
  captureBody: 'all',
  logLevel: 'trace',

});

import { ApolloServer } from '@apollo/server';
import { startStandaloneServer } from '@apollo/server/standalone';

// ---------- 1. Esquema ----------
const typeDefs = `#graphql
  type Book {
    title: String
    author: String
  }

  type Query {
    books: [Book]
  }
`;

// ---------- 2. Datos de ejemplo ----------
const books = [
  { title: 'The Awakening',  author: 'Kate Chopin' },
  { title: 'City of Glass',  author: 'Paul Auster' }
];

// ---------- 3. Resolvers ----------
const resolvers = {
  Query: {
    books: () => books
  }
};

// ---------- 4. Servidor ----------
const server = new ApolloServer({ typeDefs, resolvers });

const { url } = await startStandaloneServer(server, {
  listen: { port: 4000 }
});

console.log(`🚀  Server ready at: ${url}`);

