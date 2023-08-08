module.exports = {
  globals: {
    MyGlobal: true
  },
  extends: [
    './rules/best-practices',
    './rules/errors',
    './rules/style',
    './rules/tailwind',
    './rules/node',
    './rules/browser',
    './rules/variables',
    './rules/es6',
    './rules/strict',
  ].map(require.resolve),
  plugins: ["tailwindcss"],
  parser: "@babel/eslint-parser",
  parserOptions: {
    ecmaVersion: 14,
    sourceType: 'module',
    requireConfigFile : false
  },
  rules: {},
};
