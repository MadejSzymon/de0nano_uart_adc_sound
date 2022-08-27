clear 
COM = 'COM5';
baud_rate = 9600;
parity = 'none';
timeout = 120;
nbr_data = 5000;
data_type = "uint8";

s = serialport(COM,baud_rate,'Parity',parity,'Timeout',timeout);
data = read(s,nbr_data,data_type);
fopen(s);

plot(data)

