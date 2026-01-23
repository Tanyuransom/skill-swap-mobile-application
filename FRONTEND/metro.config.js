/**
 * Metro configuration for React Native
 * https://github.com/facebook/react-native
 */

const { getDefaultConfig } = require('expo/metro-config');
const path = require('path');

const config = getDefaultConfig(__dirname);

// Add support for @ alias
config.resolver.extraNodeModules = {
    '@': path.resolve(__dirname, 'src'),
};

module.exports = config;
