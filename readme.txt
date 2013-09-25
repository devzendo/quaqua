Making use of Quaqua via Maven
------------------------------

Add the following dependency to your pom.xml:
    <dependency>
        <groupId>org.devzendo</groupId>
        <artifactId>Quaqua</artifactId>
        <version>7.3.4</version>
    </dependency>

Ensure that org.devzendo Quaqua-7.3.4.jar is on your classpath.

Ensure that the org.devzendo LibQuaqua-7.3.4.zip containing Quaqua's native
libraries is unzipped during your package phase, and is placed somewhere that
will be present on your classpath during execution. In the following snippet, I
extract this zip into the location where DevZendo's CrossPlatformLauncherPlugin
will place all libraries, for a Mac OSX GUI .app:

    <!--
      Copy the Quaqua native libraries into the correct location in the
      Mac OS X launcher structure created above.
    -->
    <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-dependency-plugin</artifactId>
        <executions>
            <execution>
                <id>unpack-quaqua-dependencies</id>
                <phase>package</phase>
                <goals>
                    <goal>unpack</goal>
                </goals>
                <configuration>
                    <artifactItems>
                        <artifactItem>
                            <groupId>org.devzendo</groupId>
                            <artifactId>LibQuaqua</artifactId>
                            <version>7.3.4</version>
                            <type>zip</type>
                            <overWrite>true</overWrite>
                            <includes>*</includes>
                            <outputDirectory>
                                ${project.build.directory}/macosx/${appName}.app/Contents/Resources/Java/lib
                            </outputDirectory>
                        </artifactItem>
                    </artifactItems>
                    <!-- other configurations here -->
                </configuration>
            </execution>
        </executions>
    </plugin>

For more info on the CrossPlatformLauncherPlugin, please see
http://devzendo.org/content/xplp/

In your code, you can then:
UIManager.setLookAndFeel("ch.randelshofer.quaqua.QuaquaLookAndFeel");

