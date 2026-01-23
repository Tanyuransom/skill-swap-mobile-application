const { getDefaultConfig } = require('expo/metro-config');
const path = require('path');

const config = getDefaultConfig(__dirname);

// Add path alias resolution
config.resolver.extraNodeModules = {
    '@': path.resolve(__dirname, 'src'),
};

module.exports = config;
