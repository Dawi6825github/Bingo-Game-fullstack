/** @type {import('next').NextConfig} */
const nextConfig = {
    async rewrites() {
        return [
            {
                source: '/api/:path*',
                destination: 'http://localhost:8000/api/:path*'
            },
            {
                source: '/sanctum/csrf-cookie',
                destination: 'http://localhost:8000/sanctum/csrf-cookie'
            }
        ];
    },
    webpack: (config) => {
        config.externals = [...config.externals, 'canvas', 'jsdom'];
        return config;
    }
};

module.exports = nextConfig;
