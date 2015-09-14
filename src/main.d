import std.stdio;
import std.string;
import std.getopt;
import std.file;

enum Command {split, join}

Command command;

int numberofchunk = -1;
int sizeofchunk = 10*1024*1024; //10 MB
string inputfile;

int main(string[] argv)
{
	getopt(argv, 
		"command|c",  &command,
		   "numberofchunk|n",&numberofchunk,
		   "sizeofchunk|s",&sizeofchunk,
		   "file|f",&inputfile);



	int counter = 0;

	if (command == Command.split)
	{
		auto input = File(inputfile,"rb");

		if (numberofchunk == -1)
			counter = splitUsingSize(input, sizeofchunk);
		else counter = splitUsingNumberOfChunks(input, numberofchunk);

	}
	else
	{
		counter = join(inputfile);
	}
    return 0;
}

int join(string outName)
{
	auto outFile = new File(outName,"w");
	writeln(format("Output file %s.",infile));

	int counter = 1;

	do
	{
		auto infile = format("%s.%s",inputfile,counter++);
		if (exists(infile))
		{
			writeln(format("Merging file %s (%s)...",infile,read.length));
			auto f = new File(infile,"rb");
			// Create a buffer with the same size of the input file.
			auto buf = new ubyte[cast(uint)f.size()];
			buf = f.rawRead(buf);
			outFile.rawWrite(buf);
		}
		else break;
	}
	while(true);
	
	outFile.flush();
	outFile.close();

		return 0;
}

int splitUsingSize(File input, int sizeOfChunks)
{

	auto buf = new ubyte[sizeOfChunks];	
	int readSize = 0;
	int counter = 0;
	do 
	{
		auto read = input.rawRead(buf);
		readSize = read.length;
		if (readSize > 0)
		{
			auto outfile = format("%s.%s",inputfile,++counter);
			writeln(format("Creating file %s (%s)...",outfile,read.length));
			auto fout = File(outfile,"w");
			fout.rawWrite(read);
			fout.flush();
		}
	}
	while(readSize == sizeOfChunks);

	return counter;

}

int splitUsingNumberOfChunks(File input, int numberOfChunks)
{
	writeln(input.size()/numberOfChunks);
	uint number = cast(uint)input.size()/numberOfChunks;
	auto counter = splitUsingSize(input,number);
	return counter;
}