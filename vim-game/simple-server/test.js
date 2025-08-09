const assert = require('assert');
const http = require('http');

describe('MT Config Game Tests', function() {
    const port = 3002;
    
    before(function(done) {
        // Start server in child process to avoid conflicts
        const { spawn } = require('child_process');
        const path = require('path');
        this.serverProcess = spawn('node', [path.join(__dirname, 'index.js')], {
            env: { ...process.env, PORT: port },
            detached: false
        });
        
        // Wait for server to start
        setTimeout(done, 1000);
    });
    
    after(function() {
        if (this.serverProcess) {
            this.serverProcess.kill();
        }
    });
    
    describe('API Endpoints', function() {
        it('should return curriculum data', function(done) {
            http.get(`http://localhost:${port}/api/curriculum`, (res) => {
                assert.strictEqual(res.statusCode, 200);
                let data = '';
                res.on('data', chunk => data += chunk);
                res.on('end', () => {
                    const curriculum = JSON.parse(data);
                    assert(curriculum.lessons, 'Should have lessons');
                    done();
                });
            });
        });
        
        it('should return lesson list', function(done) {
            http.get(`http://localhost:${port}/api/lessons`, (res) => {
                assert.strictEqual(res.statusCode, 200);
                let data = '';
                res.on('data', chunk => data += chunk);
                res.on('end', () => {
                    const lessons = JSON.parse(data);
                    assert(Array.isArray(lessons), 'Should return array of lessons');
                    if (lessons.length > 0) {
                        assert(lessons[0].id, 'Lesson should have id');
                        assert(lessons[0].title, 'Lesson should have title');
                    }
                    done();
                });
            });
        });
    });
    
});