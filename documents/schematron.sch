<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
    <pattern>
        <rule context="char|dialogue|pointOfView|attire|aside[@handle]|sex|kiss">
            <assert
                test="for $handle in tokenize(@handle, ' ') return /troll/meta/characterList/character[./@handle eq $handle]"
                >[@HANDLE] @handle of this element must contain only handles of characters.</assert>
        </rule>
        <!--<rule context="ref">
            <assert
                test="for $handle in tokenize(@handle, ' ') return /troll/meta/referenceList/reference[./@handle eq $handle]"
                >[@HANDLE] @handle of this element must contain only handles of references.
            </assert>
        </rule>-->
        <!--Commenting this out because I forgot references were doing all sorts of things besides just the referenceList -Janis -->
        <rule context="spell">
            <assert
                test="for $handle in tokenize(@handle, ' ') return /troll/meta/spellList/spellDefinition[./@handle eq $handle]"
                >[@HANDLE] @handle of this element must contain only handles of spells.</assert>
        </rule>
        <rule context="place">
            <assert
                test="for $handle in tokenize(@handle, ' ') return /troll/meta/locationList/location[./@handle eq $handle]"
                >[@HANDLE] @handle of this element must contain only handles of places.</assert>
        </rule>
    </pattern>
    <pattern>
        <rule context="char[not(@type)]">
            <report
                test="translate(lower-case(string-join(.//text(), ' ')), &quot;'&quot;, '') = ('he', 'thy', 'she', 'i', 'you', 'u', 'me', 'my', 'we', 'us', 'they', 'thou', 'shes', 'hes', 'were', 'youre', 'ur', 'ill', 'im', 'their', 'her', 'his', 'dem', 'them', 'our', 'mine', 'him')"
                >[CHAR] This char should be marked up with @type/@person</report>
            <report
                test="@handle='enoby' and lower-case(string-join(.//text(), ' ')) = 'enoby' and (not(.//sp) or not(lower-case(string-join(.//sp/@intended, ' ')) = 'ebony'))"
                >[ENOBY] This name is misspelled and is not marked as so</report>
            <!--I think this rule is flipping shit when it shouldn't. see line 607 of main doc -Janis -->
            <!--Fixed it! -Janis -->
            <let name="charHandleAttribute" value="@handle"/>
            <report
                test="false() = (for $charPiece in .//text()
                return if($charPiece/ancestor-or-self::sp) then(true())
                else(matches(normalize-space(lower-case(/troll/meta/characterList/character[./@handle eq $charHandleAttribute]/text())),
                concat(normalize-space(lower-case($charPiece)), '\s*'))))"
                >[CHAR-SP] This name contains pieces of a name that isn't part of that character's
                correct name, and that isn't marked up as a spelling mistake</report>
        </rule>
    </pattern>
    <pattern>
        <rule context="speakingVP[paradox]">
            <assert test="paradox/verb">[SPEAKINGVP-PARADOX] This speakingVP element contains the
                paradox format, but that paradox doesn't contain a verb</assert>
        </rule>
        <rule context="paradox[not(ancestor-or-self::speakingVP)]">
            <assert test="not(verb) and not(modifier)">[PARADOX] Paradox elements may only contain
                verb and modifier elements when the paradox is within a speakingVP element</assert>
        </rule>
    </pattern>
    <pattern>
        <rule context="sentence[ancestor-or-self::chapter/@editor]">
            <let name="sentenceBaseText"
                value="lower-case(string-join(.//text()[not(ancestor-or-self::poc)], ' '))"/>
            <let name="sentenceCorrectedText"
                value="lower-case(string-join(for $node in .//text()[not(ancestor-or-self::poc)] return if(ancestor-or-self::sp) then(ancestor-or-self::sp[last()]/@handle) else($node), ' '))"/>
            <report
                test="true() = (for $keyword in ('wearing', 'put on') return contains($sentenceBaseText, $keyword)) and not(.//attire)"
                >[ATTIRE] This sentence needs to have attire marked up</report>
            <report
                test="true() = (for $keyword in ('making out', 'french', 'kiss', 'make out') return contains($sentenceBaseText, $keyword)) and
                not(.//kiss or ancestor-or-self::kiss)"
                >[KISS] This sentence contains a kiss that isn't contained in a kiss
                element.</report>
            <report
                test="true() = (for $keyword in ('do it', 'doing it', 'have sex', 'had sex', 'rape') return matches($sentenceCorrectedText, $keyword)) and
                (not(.//sex or ancestor-or-self::sex or .//ref[@handle = 'havingSex']) and not('to do it'))"
                >[SEX] This sentence contains telltale signs of sex that isn't contained in a sex
                element.</report>
            <report
                test="true() = (for $keyword in ('went to', 'go to', 'going to') return contains($sentenceCorrectedText, $keyword)) and
                not(.//place or .//ref[true() = (for $handlePiece in tokenize(./@handle, ' ') return $handlePiece = /troll/meta/locationList/location/@handle)])"
                >[PLACE] This sentence contains a reference to going to a location, but doesn't
                contain a place element</report>
            <report
                test="true() = (for $keyword in ('cast', 'spell') return (matches($sentenceBaseText, concat($keyword, '[^a-z]')) or
                matches($sentenceCorrectedText, concat($keyword, '[^a-z]'))))
                and not(.//spell)"
                >[SPELL] This sentence seems to contain a spell that isn't marked up.</report>
            <report
                test="dialogue and string-length(normalize-space(string-join(dialogue/following-sibling::text(), ' '))) > 0 and (not(dialogue/following-sibling::speakingVP) and not(dialogue/following-sibling::poc) and not(dialogue/following-sibling::redact/descendant::speakingVP) and not(dialogue/following-sibling::remove) and not(dialogue/following-sibling::paradox/descendant::speakingVP))"
                >[SPEAKINGVP] This dialogue should be followed by a speakingVP</report>
            <report
                test="matches(string-join(.//*[not(name() = sp) and not(ancestor-or-self::poc)], ' '), '[^\.][\.]{3}[^\.]')"
                >[...](Chapter. <value-of select="ancestor-or-self::chapter/@number"/>) This
                sentence contains '...', which is generally a mistake according to the printed
                copy.</report>
        </rule>
    </pattern>
    <pattern>
        <rule context="char[@person eq '1']">
            <report
                test="translate(lower-case(string-join(.//text(), ' ')), &quot;'&quot;, '') = ('he', 'thy', 'she', 'you', 'u', 'they', 'thou', 'shes', 'hes', 'youre', 'ur', 'their', 'her', 'his', 'dem', 'them', 'him')"
                >[@PERSON1] The value of @person should be 1.</report>
        </rule>
        <rule context="char[@person eq '2']">
            <report
                test="translate(lower-case(string-join(.//text(), ' ')), &quot;'&quot;, '') = ('he', 'she', 'i', 'me', 'my', 'they', 'shes', 'hes', 'were',  'ill', 'im', 'their', 'her', 'his', 'dem', 'them', 'our', 'mine', 'him')"
                >[@PERSON2] The value of @person should be 2.</report>
        </rule>
        <rule context="char[@person eq '3']">
            <report
                test="translate(lower-case(string-join(.//text(), ' ')), &quot;'&quot;, '') = ('thy', 'i', 'you', 'u', 'me', 'my', 'we', 'us', 'thou', 'were', 'youre', 'ur', 'ill', 'im', 'our', 'mine')"
                >[@PERSON3] The value of @person should be 3.</report>
        </rule>
        <rule context="char[@type eq 'pers']">
            <report
                test="translate(lower-case(string-join(.//text(), ' ')), &quot;'&quot;, '') = ('thy', 'your', 'my', 'their', 'his', 'her', 'our', 'mine', 'ur')"
                >[POSS] The value of @type should be poss.</report>
        </rule>
        <rule context="char[@type eq 'poss']">
            <report
                test="translate(lower-case(string-join(.//text(), ' ')), &quot;'&quot;, '') = ('i', 'he', 'she', 'they', 'we', 'you', 'thou', 'thee', 'him', 'her', 'dem', 'u', 'were', 'hes', 'shes', 'ill', 'im', 'us', 'youre')"
                >[PERS] The value of @type should be pers.</report>
        </rule>
        <!-- The above is creating more wrongful errors than it's solving, I think. Commenting it out for now -Janis -->
        <!-- Aha! Solved problem by flipping them so they are reports instead of asserts. That way it checks to see if the wrong pronoun is there instead of saying it can only contain the correct ones. This way it won't flip out over things like "my boyfriend" and "a voice". -Janis -->
        <!-- Yeah. Pretty much, it's been trial and error for me each time with which element it should be :3 -Jacob -->
    </pattern>
    <!-- superceded by the above dialogue rule? further testing required to confirm, however -->
    <!--What does the above rule catch that the below rule does not?-->
    <!-- the above rule catches any sentence that has dialogue, is followed by any text, but that doesn't have a speakingVP element. The text supports this
        assertion. - Jacob -->
    <!--So the above catches places where we may have also failed to markup the character who said it? -Janis -->
    <!-- the above catches any time there is any text at all after the dialogue, but that doesn't have a speakingVP. RelaxNG ensures for us that
        speakingVP elements must have a char inside of them. And the document says that any time there is text following a dialogue element,
        that text is what would be contained in a speakingVP. So the above test says that any dialogue followed by arbitrary text but that isn't followed
        by a speakingVP MUST be followed by a speakingVP, and then RelaxNG says that any speakingVP must contain a char. Does this...? -Jacob -->
    <!--I think it just looks to see if there is a following-sibling char element and if there is, then it checks to make sure that there's a speakingVP sibling following the dialogue. The RelaxNG handles what elements are allowed where, this just makes sure that if there IS a character specified after the dialogue, there is ALSO a speakingVP. -Janis-->
    <!-- Except that I thought that we were marking the char elements *inside* of the speakingVP, so the test above tests for that. I'm not entirely sure what
          you're saying right now, if you're agreeing or disagreeing, or what, so if you'd be able to explain a bit more? Sorry :x -Jacob -->
    <!--haha we are, but I'm mostly concerned with finding the places where we haven't marked up a speakingVP yet, so I'm looking for places where there's a char NOT inside a speakingVP following dialogue. Am I making sense yet? -Janis -->
    <!-- Ah, you are! Okay :P Except that I think the above test does that, plus more. Because when we have <char>, it isn't empty, so it is picked up
        with the .//text(), so that if we have a <char> element outside of the <speakingVP>, it picks it up because there is content/text after the dialogue's end
        in the sentence; and if we haven't marked up a <char> or anything after the dialogue (like at the beginning, before we were marking up ALL characters,
        the above test will alert us to that as well. So it does the jobs of both. Not sure if you're disagreeing or if you're agreeing and just want to
        explain your point/purpose. Either way, we can enable both rules - won't break anything if we do. I like your solution by the way :3 Elegant - Jacob -->
    <!-- Yes, yours does more because it's more general, which, given the mixed-up state of our markup, is probably a really good thing. (commas everywhereee! sorry lol.) basically i just wanted to check what yours was intended to catch that mine wasn't, which we've covered now. :D We CAN enable both rules but I don't think we need to/should- yours catches all the things mine does and then some. Thanks ^^. -Janis -->
    <!-- Can you think of any other rules that we can work on, perhaps together? :3 -->
    <!--Not really a joint effort thing, but one of us could use the char @handle checker rule as a base to create rules which do the same only for references and spells etc. Aside from that, nothing comes to mind offhand but if I think of something I'll let you know. -Janis-->
    <!-- Or if someone wants to go through and use the [ENOBY] rule as a guide to write one for other commonly misspelled characters we have,
        like Dumblydore; characters that we changed their official name during markup. And I've been putting an abbreviated something before the text
        of the rule (ie, [ENOBY]) so that we can sort the validation errors by text and have all of the rules look distinct when we're going through them.
        I find it to be massively more helpful :3 - Jacob -->
    <!--I reallly like that sort of naming convention. :D Also, we might make rules that check to make sure you've gotten the @person value right, because I know at least I sometimes get carried away. -Janis -->
    <!--Added rules for that above. Made 3 separate ones but if you can think of a way to combine them, by all means do. -Janis -->
    <!-- I love the @person rules :3 Thanks for those! What else can we do? See, isn't this rather fun to write? :3 - Jacob -->
    <!--No problem. :D Haha fun, yes, but I should really be doing other workkk lol. Ummm, no ideas atm- will get back to you. -Janis -->
    <!--    <pattern>
        <rule context="dialogue[following-sibling::char]">
            <assert test="following-sibling::speakingVP">Dialogue with speaking verb must be marked
                up.</assert>
        </rule>
    </pattern>-->
</schema>
