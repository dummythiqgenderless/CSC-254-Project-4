#Putting the output of the llvm dwarf dump into a text file 
# system("llvm-dwarfdump --debug-line > llvmdwarfdump.txt")
require 'set'
llvmdwarfdump_file = File.open("llvmdwarfdump.txt")
llvmdwarfdump_lines = llvmdwarfdump_file.readlines.map(&:chomp)

# Create a dictionary that contains the file names and ids 
fileids = Hash.new 
#Create a dictionary to hold the addresses, line, and file 
table = Hash.new 
#Contains the addresses 
addresses = Array.new.to_s
filesneeded = Set.new 
FILE_NUM = /file_names\[\s*(\d+)\]:/
FILE_ID = /name:\s"(.*)"/
ADDRESSLINE = /0x0*([0-9][0-9a-f]*)\s*(\d+)\s*\d+\s*(\d).*/
STRING_STMT = /is_stmt/
last = (llvmdwarfdump_lines.length) - 1 
#Iterates through the file, and captures the file name with it's number and the table information
for i in 0 .. last 
	filenum = llvmdwarfdump_lines[i].match(FILE_NUM)
	stringFlag = llvmdwarfdump_lines[i].match(STRING_STMT)
	#File name and number
	if filenum != nil 
		filenam = llvmdwarfdump_lines[i+1].match(FILE_ID)
		fileids.store(filenum[1], filenam[1])
	end
    if stringFlag != nil
        addressline = llvmdwarfdump_lines[i].match(ADDRESSLINE)
		if addressline != nil 
			#Captures the line and file 
            linefile = [addressline[2], addressline[3]]
            #Store the addresses in the table 
            addresses.push[addressline[1]]
			#Add the line and file to the table 
			table.store(addressline[1], linefile)
			#Delete whatever irrelevant files we have in the order table (there's significantly more files than we need)
            filesneeded.add(addressline[3])
        end
    end
end 

puts table 
puts addresses 
puts fileids
filesneeded.each do |n|
    # Display the element.
    puts n
end

#extraction goes from here, undone
#dict of add-line
obd_scHash = Hash.new
#dict of add-everything
obdHash = Hash.new
#dict of line-everything
scHash = Hash.new

obd_file = File.open("obd.txt")
obd_lines = obd_file.readlines.map(&:chomp)
lastobd = (odd_lines.length) - 1 
for j in 0 .. (addresses.length - 1)
    addressStart = address[j]
    addressEnd = address[j + 1]
    matched = false
    obdChuncks = ""
    for i in 0 .. lastobd
        if obd_lines[i].match(addressStart) != nil
            matched = true
        end
        if matched == true 
            if obd_lines[i].match(addressStart) == nil
                obdChuncks + (obd_lines[i]) + "\n"
            end
        end
    end
    obdHash.store(addresses[j], obdChuncks)
end
puts obdHash


=begin 

Creating a table that contains the C code and the object code all in one table 


*Brainstorming* 

First, iterate through the addresses. For each address, we get the 
line and the file number. Then, we go to the file hash, and get the file name.
Then open the file, and grab that line number. We then put that line 
number in the table. Then, we grab the matching address in the obd hash file 


Change of plans -> 

Put all 

=end 


for i in 0 .. (addresses.length - 1)
	#Current Address 
	curraddress = addresses[i]
	#Get the file number and file name 
	linefile = table[curraddress]
	#Get the file number 
	file = linefile[1]
	#Use the file number to get the file name 
	filename = fileids[file]
	#Open the file name  
	text = File.open(filename)
	#Splits the text
	lines = text.split(/\r*\n/)

	#Not exactlyyyyyyyy sure what I'm doing right here lmfao 

	#Add line numbers to each line in the file 
	line = 1 
	head = "<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/></head>\n<body><pre>"
	lines.each do |line| 
		line = "<a name=\""+counter.to_s+"\">"+line+"</a>\n"
		text += line
		counter = counter + 1
	end

	#Add HTML ending formats
	text = text + "</pre></body></html>"

end 

=begin 
#Brainstorming for HTML

so essentially, from what i understand, things are grouped into chunks 

so on one chunk, we have the obj dump code which contains the object dump 
and the other code which contains the C code 

so i think we would just have to 


=end 














