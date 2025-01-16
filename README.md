# Random Password Generator

This program generates random passwords of a user-specified length using the Zig programming language.

## Description

The Random Password Generator prompts the user for the desired password length and generates a random password containing digits, lowercase letters, uppercase letters, and symbols. The password length should be between 4 and 128 characters.

Here's break down the code step by step and explain its performance and processes:

### 1. Importing Standard Libraries
The code begins by importing necessary standard libraries:
```zig
const std = @import("std");
const random = @import("std").Random;
```
This allows us to use standard input/output functions and the random number generator.

### 2. Main Function
The `main` function serves as the entry point of the program. It orchestrates the overall password generation process:
```zig
pub fn main() !void {
```

### 3. Standard I/O and Allocator
The code sets up standard input/output and a memory allocator:
```zig
const stdout = std.io.getStdOut().writer();
const stdin = std.io.getStdIn().reader();
const allocator = std.heap.page_allocator;
```
This enables reading from the console and managing memory allocation dynamically.

### 4. User Prompt for Password Length
The program prompts the user to enter the desired password length and ensures it fits within the specified bounds (4 to 128 characters):
```zig
std.debug.print("The password length should not be less than 4 and should not exceed 128 characters.\n", .{});
try stdout.print("Length: ", .{});
const length_input = try allocator.alloc(u8, 64);
defer allocator.free(length_input);

var length_str = try stdin.readUntilDelimiterOrEof(length_input, '\n') orelse return;
// Manually remove any newline characters
while (length_str[length_str.len - 1] == '\n' or length_str[length_str.len - 1] == '\r') {
    length_str = length_str[0 .. length_str.len - 1];
}
std.debug.print("Length: {s}\n", .{length_str});

const length: usize = try std.fmt.parseInt(usize, length_str, 10);
```

### 5. Validating Password Length
The program validates the password length to ensure it is within the acceptable range:
```zig
if (length < 4) {
    try stdout.print("Password length must be >= 4 to include all character types!\n", .{});
    return;
}
if (length > 128) {
    try stdout.print("Password length must be <= 128!\n", .{});
    return;
}
```

### 6. Defining Character Pools
Various character pools are defined:
```zig
const digits = "0123456789";
const lowers = "abcdefghijklmnopqrstuvwxyz";
const uppers = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
const symbols = "!@#$%^&*()";

const digits_len = digits.len;
const lowers_len = lowers.len;
const uppers_len = uppers.len;
const symbols_len = symbols.len;
```
These pools contain digits, lowercase letters, uppercase letters, and symbols that will be used to generate the password.

### 7. Allocating Memory for Password

Memory is allocated for storing the password:
```zig
const password = try allocator.alloc(u8, length + 1);
defer allocator.free(password);
@memset(password, 0);
```

### 8. Initializing Random Number Generator

The random number generator is seeded with the current timestamp:
```zig
const timeStamp = std.time.milliTimestamp();
const seed: u64 = @intCast(timeStamp);
std.debug.print("Seed: {}\n", .{seed});
var rng = random.DefaultPrng.init(seed);
```

### 9. Ensuring Each Character Type is Represented

The first four characters of the password are guaranteed to include one character from each pool (digits, lowercase, uppercase, symbols):
```zig
password[0] = digits[rng.next() % digits_len];
password[1] = lowers[rng.next() % lowers_len];
password[2] = uppers[rng.next() % uppers_len];
password[3] = symbols[rng.next() % symbols_len];
```

### 10. Filling the Rest of the Password

The remaining characters are filled randomly using all character pools:
```zig
for (password[4..]) |*char| {
    const char_type = rng.next() % 4;
    char.* = switch (char_type) {
        0 => digits[rng.next() % digits_len],
        1 => lowers[rng.next() % lowers_len],
        2 => uppers[rng.next() % uppers_len],
        else => symbols[rng.next() % symbols_len],
    };
}
```

### 11. Shuffling the Password

The Fisher-Yates algorithm is used to shuffle the password to ensure random distribution:
```zig
var idx: usize = length - 1;
while (idx > 0) : (idx -= 1) {
    const swap_idx = rng.next() % (idx + 1);
    const temp = password[idx];
    password[idx] = password[swap_idx];
    password[swap_idx] = temp;
}
```

### 12. Null-Terminating and Printing the Password

The password is null-terminated and printed:
```zig
// Ensure null termination and print
password[length] = 0;
try stdout.print("Password: {s}\n", .{password[0..length]});
}
```

### Performance Considerations

- **Efficiency**: The algorithm ensures that the password generation is efficient, leveraging the random number generator and character pools.
- **Security**: By ensuring at least one character from each type and using a shuffling algorithm, the generated passwords are secure and randomized.
- **User Input Validation**: The program validates user input to ensure it meets the required constraints, providing feedback if it does not.

This code demonstrates a thorough and robust approach to generating secure random passwords, ensuring both randomness and adherence to user-specified constraints. Well done on cracking this challenging problem! 👏 If you have any more questions or need further assistance, feel free to ask. 😊

## Author

[Chieng Sisovin](https://github.com/sisovin)

## Usage

1. Clone the repository.
2. Navigate to the project directory.
3. Run the program using Zig.

### Example

```sh
PS D:\ZigProjects\Password_Generator> zig run .\src\main.zig
Length: 32
Length: 32
Seed: 1736935141685
Seed: 1736935141685
Password: !(1DEJ6L%#W3Gh!00NEzv&$1*^7#@U%6

PS D:\ZigProjects\Password_Generator> zig run .\src\main.zig
Length: 64
Length: 64
Seed: 1736937329880
Seed: 1736937329880
Password: )@x!#v5@j%^9rw^aE@%4l40vU24^wt^#*oD089YE!Fv%w7Cy@X2^*19k^G@2O7%c

PS D:\ZigProjects\Password_Generator> zig run .\src\main.zig
Length: 128
Length: 128
Seed: 1736937232025
Seed: 1736937232025
Password: &DIZnA%1W0K7X!f2Vv8f3v27!!WQ4&kzi#2nr61AP&)y)5k@6!0u3i!m)PM46Hj%46i2QjX(RM2(0#m((3C92AGf3@Yy&65FEoD9%&^i#c8imCC)ta1$6((7$&Z5(89S
```

## How to Push the Project to GitHub

1. Initialize a new Git repository:
    ```sh
    git init
    ```

2. Add all files to the repository:
    ```sh
    git add .
    ```

3. Commit the changes:
    ```sh
    git commit -m "Initial commit"
    ```

4. Create a new repository on GitHub.

5. Add the remote repository URL:
    ```sh
    git remote add origin https://github.com/sisovin/Zig_Password_Generator.git
    ```

6. Push the changes to GitHub:
    ```sh
    git push -u origin master
    ```
