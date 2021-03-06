sub htmlPrint{
	my ($progPath, $prog, $htF, $iFol, $isOnlyStat, $inpFs, $statFile, $oFol, $fileNames4HTML) = @_;
	my $imgPath = $progPath . "lib/imgs";
	my $cssPath = $progPath . "lib";
	my $analMsg1 = ($isOnlyStat)?"":"and filtering";
	my ($file1, $file2) = split(":::::", $inpFs);
	open(SF, "<$statFile") or print "Can not open statistics file: $statFile\n";
	my @statFData = <SF>;
	close(SF);
	my $statFileOnlyName = getFileName($statFile);
	my ($t, $priAdaLib, $linker, $isHPTOn, $HPLen, $isLenFOn, $minLen, $cutLen, $cutQual, $nCPUs, $onlySOnOff);
	my $ind = 2;
	($t, $t, $priAdaLib) = split(/ {2,}|\t/, $statFData[$ind]); $ind++;
	($t, $t, $linker) = split(/ {2,}|\t/, $statFData[$ind]); $ind++;
	($t, $t, $isHPTOn) = split(/ {2,}|\t/, $statFData[$ind]); $ind++;
	if($isHPTOn =~ /Off/) {
		$HPLen = "NA";
	}
	else {
		($t, $t, $HPLen) = split(/ {2,}|\t/, $statFData[$ind]); $ind++;
	}
	($t, $t, $isLenFOn) = split(/ {2,}|\t/, $statFData[$ind]); $ind++;
	if($isLenFOn =~ /Off/) {
		$minLen = "NA";
	}
	else {
		($t, $t, $minLen) = split(/ {2,}|\t/, $statFData[$ind]); $ind++;
	}
	($t, $t, $cutLen) = split(/ {2,}|\t/, $statFData[$ind]); $ind++;
	($t, $t, $cutQual) = split(/ {2,}|\t/, $statFData[$ind]); $ind++; $ind++;
	($t, $t, $nCPUs) = split(/ {2,}|\t/, $statFData[$ind]);
	$onlySOnOff = ($isOnlyStat)?"On":"Off";
	my ($outSeqFile, $outQualFile, $lenDistF1, $baseCntF1, $gcDistF1, $qualDistF1, $sumPieFPE, $sumPieF);
	($outSeqFile, $outQualFile, $lenDistF1, $baseCntF1, $gcDistF1, $qualDistF1, $sumPieFPE, $sumPieF) = @$fileNames4HTML;
	#($outFile1, $outFile2, $unPaired, $avgQF1, $avgQF2, $baseCntF1, $baseCntF2, $gcDistF1, $gcDistF2, $qualDistF1, $qualDistF2, $sumPieF) = @$fileNames4HTML if($isPairedEnd);
	$outSeqFile = getFileName($outSeqFile);
	$outQualFile = getFileName($outQualFile);
	#$unPaired = getFileName($unPaired) if($isPairedEnd);
	my $inpFilesMsg;
	$inpFilesMsg = "input file,  $file1(A),";
	#$inpFilesMsg = "both input files,  $file1(A) and $file2(B)," if($isPairedEnd);
	my $b4A4Msg;
	$b4A4Msg = "before and after QC";
	$b4A4Msg = "before QC" if($isOnlyStat);
	#### Getting current time
	my @months = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
	my @weekDays = qw(Sun Mon Tue Wed Thu Fri Sat Sun);
	my ($second, $minute, $hour, $dayOfMonth, $month, $yearOffset, $dayOfWeek, $dayOfYear, $daylightSavings) = localtime();
	my $year = 1900 + $yearOffset;
	#my $theTime = "$hour:$minute:$second, $weekDays[$dayOfWeek] $months[$month] $dayOfMonth, $year";
	my $theTime = "$weekDays[$dayOfWeek] $months[$month] $dayOfMonth, $year";
	open(O,">$htF") or die "Can not create HTML file: $htF\n";
	##### Get a toolkit version
	open(V, $progPath."lib/version");
	my $version = <V>;
	close(V);

print O <<EOF;
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
	<html>
	<head>
	<title>NGS QC Toolkit</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	
	
	<style>
		BODY {
			margin-top: 0;
			background-repeat: repeat;
			font-family: Arial, Helvetica, sans-serif;
			font-size: 5px;
			margin-bottom: 0;
		}
		.cnt {
			font-family: Verdana, Arial, Helvetica, sans-serif;
			font-size: 12px;
			line-height: 20px;
			padding: 5px 20px 0px;
		}
		Table .exp {
			font-family: Verdana, Arial, Helvetica, sans-serif;
			font-size: 13px;
			line-height: 20px;
		}
		TD .padding {
			padding: 0px 20px;
		}
		.head1 {
			font-size: 18px;
			font-weight: bold;
			padding: 5px 0px;
		}
		.head2 {
			font-size: 14px;
			font-weight: bold;
			padding: 5px 0px;
		}
		.head3 {
			font-size: 12px;
			font-weight: bold;
		}
		A {
			text-decoration: none;
			color: #0000FF;
		}
		.tblBg TABLE TD {
			background-color: #EEEEEE;
		}
		.tblBg2 TABLE TD {
			background-color: #E1E1E1;
		}
	</style>
	
	</head>
	
	<body bgcolor="#bbbbbb">
	<table align="center" width="900" cellspacing="0" cellpadding="0" bgcolor="#ffffff" border="0">
	
		<tr>
			<td width="17" rowspan="6">&nbsp;</td>
			<td height="150" bgcolor="#E1E1E1"><center><a href="http://www.nipgr.res.in/ngsqctoolkit.html"><b><font  style="font-size: 50px;">NGS QC T</font><font style="font-size: 40px;">OOLKIT</font></b></center></a>
			</td>
			<td width="17" rowspan="6"></td>
		</tr>
		<tr>
			<td valign="top" class="tblBg">
			<div class="cnt">
				<table class="cnt" width="100%" border="0">
					<tr>
						<td class="head1">Results of quality control (QC) using $prog v$version <font style="font-size:10px">($theTime)</font></td>
					</tr>
					<tr>
						<td class="head2">Input files and parameters:</td>
					</tr>
					<tr><td class="tblBg2">
						<table width="100%" border="0" class="cnt">
						<tr>
							<td>Analysis type</td><td>Quality check $analMsg1 of 454 paired-end sequencing data</td>
						</tr>
						<tr>
							<td>Input file directory</td><td><a href="file://$iFol" target="_blank">$iFol</a></td>
						</tr>
						<tr>
							<td>Input sequence file</td><td>$file1</td>
						</tr>
						<tr>
							<td>Input quality file</td><td>$file2</td>
						</tr>
						<tr>
							<td>Input file format</td><td>454 format (FASTA and QUAL)</td>
						</tr>
						<tr>
							<td>Primer/Adaptor library</td><td>$priAdaLib</td>
						</tr>
						<tr>
							<td>Linker sequence</td><td>$linker</td>
						</tr>
						<tr>
							<td>Homopolymer trimming</td><td>$isHPTOn</td>
						</tr>
						<tr>
							<td>Length of the homopolymer to be removed</td><td>$HPLen</td>
						</tr>
						<tr>
							<td>Length filter</td><td>$isLenFOn</td>
						</tr>
						<tr>
							<td>Cut-off for minimum read length</td><td>$minLen</td>
						</tr>
						<tr>
							<td>Cut-off read length for HQ</td><td>$cutLen</td>
						</tr>
						<tr>
							<td>Cut-off quality score</td><td>$cutQual</td>
						</tr>
						<tr>
							<td>Only statistics</td><td>$onlySOnOff</td>
						</tr>
						<tr>
EOF
print O "
							<td>Number of ". (($prog=~/_PRLL/)?"CPUs":"processes") ."</td><td>$nCPUs</td>
\n";
print O <<EOF;
						</tr>
						</table>
					</td>
					</tr>
					<tr>
						<td class="head2">Output files:</td>
					</tr>
					<tr><td class="tblBg2">
						<table width="100%" border="0" class="cnt">
						<tr>
							<td>Output folder</td><td><a href="file://$oFol" target="_blank">$oFol</a></td>
						</tr>
						<tr>
							<td>QC statistics</td><td><a href="$statFileOnlyName" target="_blank">$statFileOnlyName</a></td>
						</tr>
EOF
if(!$isOnlyStat) {
print O <<EOF;
						<tr>
							<td>High quality filtered sequence file</td><td>$outSeqFile</td>
						</tr>
						<tr>
							<td>High quality filtered quality file</td><td>$outQualFile</td>
						</tr>
EOF
}
print O <<EOF;
						<tr>
							<td>Length distribution</td><td><a href="$lenDistF1" target="_blank">$lenDistF1</a></td>
						</tr>
						<tr>
							<td>Base composition</td><td><a href="$baseCntF1" target="_blank">$baseCntF1</a></td>
						</tr>
						<tr>
							<td>GC content distribution</td><td><a href="$gcDistF1" target="_blank">$gcDistF1</a></td>
						</tr>
						<tr>
							<td>Quality distribution</td><td><a href="$qualDistF1" target="_blank">$qualDistF1</a></td>
						</tr>
						<tr>
							<td>Summary of QC (Paired reads)</td><td><a href="$sumPieFPE" target="_blank">$sumPieFPE</a></td>
						</tr>
						<tr>
							<td>Summary of QC (Unpaired reads)</td><td><a href="$sumPieF" target="_blank">$sumPieF</a></td>
						</tr>
						</table>
					</td>
					</tr>
					<tr>
						<td class="head2" style="background-color: #ffffff;">&nbsp;</td>
					</tr>
					<tr>
						<td class="head2">Results of QC</td>
					</tr>
EOF
my $flag = 0;
for(my $i=0; $i<@statFData; $i++) {
	my $line = $statFData[$i];
	if($line =~ /^QC statistics/) {
		$flag = 1;
		print O "<tr><td class=\"head3\">QC statistics</td></tr>\n<tr><td class=\"tblBg2\"><table width=\"100%\" border=\"0\" class=\"cnt\">\n";
		next;
	}
	if($line =~ /^Detailed QC statistics/) {
		$flag = 2;
		print O "</table></td></tr>\n<tr><td class=\"head3\">Detailed QC statistics</td></tr>\n<tr><td class=\"tblBg2\"><table width=\"100%\" border=\"0\" class=\"cnt\">\n";
		next;
	}
	chomp($line);
	if($flag != 0 && $line ne "") {
		if($line =~ /^\* /) {
			print O "<tr><td><font size=\"1\">$line<br>";
			$i++;
			print O "&nbsp;&nbsp;$statFData[$i]</font></td></tr>\n";
			next;
		}
		if($line =~ /^\-\-\-\-\-/) {
			print O "<tr><td colspan=\"3\">$line-----------------------------------</td></tr>\n";
			next;
		}
		my @clms = split(/ {2,}|\t/, $line);
		shift(@clms);
		my $bold = 0;
		$bold = 1 if($line =~ /QC analysis of [^\n]+\:/);
		print O "<tr><td colspan=\"3\">&nbsp;</td></tr>\n" if($bold);
		print O "<tr>";
		foreach my $f (@clms) {
			print O "<td>$f</td>" if(!$bold);
			print O "<td><b>$f</b></td>" if($bold);
		}
		print O "</tr>\n";		
	}
}
print O "</table></td></tr>\n";
print O <<EOF;							
					<tr>
						<td class="head3">Summary of QC (Paired reads)</td>
					</tr>
					<tr>
						<td>
							<table width="100%" border="0" class="cnt">
								<tr>
									<td><div align="justify">Following pie chart shows the summary of QC of Paired reads depicting percentage of high quality, trimmed (homopolymer and/or contamination) and trashed (low quality and/or short) paired read, and unpaired reads (one of the paired reads which passed QC).</div></td>
								</tr>
								<tr>
									<td align="center"><img src="$sumPieFPE" border="1"><br><b>(A)</b></td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td class="head3">Summary of QC (Unpaired reads)</td>
					</tr>
					<tr>
						<td>
							<table width="100%" border="0" class="cnt">
								<tr>
									<td><div align="justify">Following pie chart shows the summary of QC of Unpaired reads depicting percentage of high quality, trimmed (homopolymer and/or contamination) and trashed (low quality and/or short) reads.</div></td>
								</tr>
								<tr>
									<td align="center"><img src="$sumPieF" border="1"><br><b>(A)</b></td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td class="head3">Length distribution</td>
					</tr>
					<tr>
						<td>
							<table width="100%" border="0" class="cnt">
								<tr>
									<td><div align="justify">Following graph(s) show number of reads for sequence length range for $inpFilesMsg $b4A4Msg.</div></td>
								</tr>
								<tr>
									<td align="center"><img src="$lenDistF1" border="1"><br><b>(A)</b>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td class="head3">GC content distribution</td>
					</tr>
					<tr>
						<td>
							<table width="100%" border="0" class="cnt">
								<tr>
									<td><div align="justify">Following graph(s) show number of reads for distinct average GC content (%) ranges for $inpFilesMsg $b4A4Msg.</div></td>
								</tr>
								<tr>
									<td align="center"><img src="$gcDistF1" border="1"><br><b>(A)</b>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td class="head3">Quality distribution</td>
					</tr>
					<tr>
						<td>
							<table width="100%" border="0" class="cnt">
								<tr>
									<td><div align="justify">Following graph(s) show number of reads for different average PHRED quality scores for $inpFilesMsg $b4A4Msg.</div></td>
								</tr>
								<tr>
									<td align="center"><img src="$qualDistF1" border="1"><br><b>(A)</b>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td class="head3">Base composition</td>
					</tr>
					<tr>
						<td>
							<table width="100%" border="0" class="cnt">
								<tr>
									<td><div align="justify">Following graph(s) show base composition (count) for $inpFilesMsg $b4A4Msg with percentage of bases at the bottom.</div></td>
								</tr>
								<tr>
									<td align="center"><img src="$baseCntF1" border="1"><br><b>(A)</b>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</div>
			</td>
		</tr>
		<tr><td style="font-size: 11px;" align="center" valign="middle" height="25" background="$imgPath/btmLine.png" bgcolor="#EEEEEE">For Questions and Suggestions, contact <a href="mailto:mjain\@nipgr.res.in">Mukesh Jain (mjain\@nipgr.res.in)</a>; <a href="mailto:ravipatel\@nipgr.res.in">Ravi Patel (ravipatel\@nipgr.res.in)</a></td></tr>
	
		<!--- <tr><td colspan="3"><img src="$imgPath/down.png"></td></tr> --->
	</table>
	</body>
	</html>
EOF

close(O);
}
1;
