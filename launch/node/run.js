import { spawn } from 'node:child_process';
import process from 'node:process';

const fizzbuzz = spawn('./build/fizzbuzz', ['serve'], {stdio: 'inherit'});

process.on('SIGINT', () => fizzbuzz.kill('SIGINT'));
process.on('SIGTERM', () => fizzbuzz.kill('SIGTERM'));

