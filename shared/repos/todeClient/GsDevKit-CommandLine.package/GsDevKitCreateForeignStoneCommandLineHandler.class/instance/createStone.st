activations
createStone
	| stoneDirectory newStoneInfo |
	Transcript
		cr;
		show: 'Creating foreign stone ' , self stoneName.
	stoneDirectory := self gs_stonesHome / self stoneName.
	stoneDirectory exists
		ifTrue: [ 
			self stoneInfo gsVers = self gsVers
				ifFalse: [ 
					self
						exitFailure:
							'Attempting to create new stone with GemStone version ' , self gsVers printString
								, ', but stone has already been created using GemStone version ' , self stoneInfo gsVers printString , '.' ].
			self stderr
				nextPutAll: stoneDirectory pathString , ' already exists.';
				lf;
				nextPutAll: 'To replace it, remove or rename it and rerun this script';
				lf.
			self exitSuccess ].
	stoneDirectory createDirectory.
	self
		createProductLn: stoneDirectory;
		createEmptySubDirectories: stoneDirectory;
		createEmptyStatsSubDirectories: stoneDirectory;
		copyTemplateFiles: stoneDirectory;
		yourself.
	(newStoneInfo := self stoneInfoClass new
		stoneName: self stoneName;
		gsVers: self gsVers;
		yourself) exportTo: stoneDirectory / self stoneInfoFilename.
	self createTodeDescription: newStoneInfo.
	Transcript
		cr;
		tab;
		show: 'Finished creating foreign stone' , self stoneName;
		cr.
	self exitSuccess