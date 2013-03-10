Waschi-cli
==========

<a href="http://flattr.com/thing/1158370/fliiiixwaschi-cli-on-GitHub" target="_blank">
<img src="http://api.flattr.com/button/flattr-badge-large.png" alt="Flattr this" title="Flattr this" border="0" /></a>   
Ruby-client for http://waschi.org 

![find a random object](https://github.com/fliiiix/waschi-cli/blob/master/img/find_random.png?raw=true)

###Setup
You need Ruby, i try it with ruby 1.9.3p362 if you have an other version and it don't work create an [Issue](https://github.com/fliiiix/waschi-cli/issues).

1. Download washi.rb to $Location
2. chmod +x washi.rb
3. Create a link to a folder in your path like this ln -s $Location/washi.rb /usr/local/bin/washi
4. Reaload your $PATH variable with a Restart or something like "source .bashrc"
5. ???
6. Profit

On my setup $Location is ~

###Commands
<pre>
Usage:
   -w object or --wash object      Wash some object
   -f object or --find object      Find some object
   --serverlist                    Print a list with the Servers

   If you have no idea for an object you can generate one with
   --object
   Example:
   -f --object
</pre>

###Problem?
Create an [Issue](https://github.com/fliiiix/waschi-cli/issues)

###Credits & License
* MeikoDis creator of http://waschi.org/ 
* Revengeday for the Pointlessword API
* License

Copyright (c) 2013, [l33tname](http://identi.ca/l33tname)  
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met: 

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer. 
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
