# hwinfo-update
PowerShell scripts that fetches the latest portable version of [HWiNFO](https://www.hwinfo.com) (stable or beta, whichever's newer) from [SourceForge](https://sourceforge.net/) or [HWiNFO.com](https://www.hwinfo.com/), extracts the 64-bit exe into the current working directory (overwriting any that may already be there), and then deletes the zip-file again.

So you don't have to do all of that yourself.

It doesn't really handle failures gracefully. Maybe that'll come later.
