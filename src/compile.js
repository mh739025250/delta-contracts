import * as path from 'path'
import * as fs from 'fs'
import solc from 'solc'

const __dirname = path.resolve();

export default function compile() {
    const filePath = path.resolve(__dirname, "contracts");
    let sources = {};
    fs.readdirSync(filePath).forEach(file => {
        let sourceCode = fs.readFileSync(path.join(filePath, file), 'UTF-8');
        sources[file] = {content: sourceCode};
    });
    let input = {
        language: 'Solidity',
        sources: sources,
        settings: {
            outputSelection: {
                '*': {
                    '*': ['*']
                }
            }
        }
    };
    return JSON.parse(solc.compile(JSON.stringify(input)));
}

