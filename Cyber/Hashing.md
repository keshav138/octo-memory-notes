Hashing is a one-way mathematical function that permanently scrambles data into a fixed-length code, which is useful because it allows you to securely verify data without ever needing to store or expose the original information. 

Why Can't We Go Back to the Original Data?

- **Information loss:** Hash functions take inputs of any size and compress them into a smaller, fixed-size output (like a digital fingerprint). Just like you cannot un-grind hamburger meat back into a steak, the system throws away data during the scrambling process, making mathematical reversal impossible.
- **Many-to-one mapping:** Because the input possibilities are endless and the output size is fixed, multiple different inputs can theoretically produce the same hash output (known as a collision). The hash doesn't know which original input created it.
- **The Avalanche Effect:** Hash algorithms use non-linear transformations and bit dependencies. Changing a single character in your original input completely changes the resulting hash output, leaving no trackable pattern or relationship to reverse-engineer.

What Is the Use of Hashing?

- **Secure password storage:** Websites store the hash of your password rather than your actual password. When you log in, the system hashes what you typed and compares the new hash to the saved hash; if they match, you get in without the server ever knowing your real password.
- **File integrity checks:** Software providers publish the hash code of a download. You can run a hash check on your downloaded file to confirm it matches, proving it was not corrupted or modified by a hacker.
- **Digital signatures and blockchain:** Hashing locks data blocks together in cryptocurrencies like Bitcoin and verifies that digital documents have not been tampered with. 

`if multiple inputs can generate the same hash is that not inconsistent, cant it be cheated`

**No, it is not inconsistent, but it is a theoretical risk called a "collision."** In practice, it is nearly impossible to cheat modern hashing algorithms because the odds of finding two inputs that match are astronomically low.

Here is how hashing handles this problem without breaking:

Why It's Not "Inconsistent"

A hash function is still completely consistent because it is deterministic: **the exact same input will always produce the exact same hash.**

The fact that two _different_ inputs can produce the same hash is just a mathematical certainty known as the **Pigeonhole Principle**. If you have 10 pigeons but only 9 holes, at least one hole must contain more than one pigeon. Because there are infinite possible inputs but a finite number of hash outputs, duplicates must exist.

Why It Can't (Easily) Be Cheated

To cheat a system—like logging into someone else's account—a hacker can't just find _any_ two files that match. They have to find a specific input that matches **your** specific password hash. This property is called **Pre-image Resistance**, and it keeps hashing secure for three reasons:

- **The Search Space is Mind-Bogglingly Huge:** A standard SHA-256 hash has 2²⁵⁶ possible combinations. That number is roughly **115⁷⁵ followed by 75 zeros**—far more than the total number of atoms in the observable universe.
- **No Clues or Patterns:** Because of the "Avalanche Effect," changing one letter in a guess doesn't bring a hacker "closer" to the correct hash. It randomly changes the entire output. The only way to find a match is pure, random guessing.
- **The Universe Will End First:** If you harnessed all the world's supercomputers to guess inputs to match a specific SHA-256 hash, it would still take **billions of years** to find one by chance.

When Hashing _Does_ Get Cheated (Broken Algorithms)

When an algorithm's math is flawed, hackers find shortcuts to generate matching hashes without guessing randomly. When this happens, the algorithm is considered **broken** and is retired:

- **MD5 & SHA-1:** These older hashing methods were found to have mathematical weaknesses. Hackers figured out how to create two completely different files (like a good program and malware) that generated the exact same hash.
- **Modern Standards:** Today, security systems use **SHA-256, SHA-3, or bcrypt**, which have no known operational shortcuts and remain completely secure against cheating.