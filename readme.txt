Making use of Quaqua via Maven
------------------------------

Add the following dependency to your pom.xml:
    &lt;dependency&gt;
        &lt;groupId&gt;org.devzendo&lt;/groupId&gt;
        &lt;artifactId&gt;Quaqua&lt;/artifactId&gt;
        &lt;version&gt;7.3.4&lt;/version&gt;
    &lt;/dependency&gt;

Ensure that org.devzendo Quaqua-7.3.4.jar is on your classpath.

Ensure that the org.devzendo LibQuaqua-7.3.4.zip containing Quaqua's native
libraries is unzipped during your package phase, and is placed somewhere that
will be present on your classpath during execution. In the following snippet, I
extract this zip into the location where DevZendo's CrossPlatformLauncherPlugin
will place all libraries, for a Mac OSX GUI .app:

    &lt;!--
      Copy the Quaqua native libraries into the correct location in the
      Mac OS X launcher structure created above.
    --&gt;
    &lt;plugin&gt;
        &lt;groupId&gt;org.apache.maven.plugins&lt;/groupId&gt;
        &lt;artifactId&gt;maven-dependency-plugin&lt;/artifactId&gt;
        &lt;executions&gt;
            &lt;execution&gt;
                &lt;id&gt;unpack-quaqua-dependencies&lt;/id&gt;
                &lt;phase&gt;package&lt;/phase&gt;
                &lt;goals&gt;
                    &lt;goal&gt;unpack&lt;/goal&gt;
                &lt;/goals&gt;
                &lt;configuration&gt;
                    &lt;artifactItems&gt;
                        &lt;artifactItem&gt;
                            &lt;groupId&gt;org.devzendo&lt;/groupId&gt;
                            &lt;artifactId&gt;LibQuaqua&lt;/artifactId&gt;
                            &lt;version&gt;7.3.4&lt;/version&gt;
                            &lt;type&gt;zip&lt;/type&gt;
                            &lt;overWrite&gt;true&lt;/overWrite&gt;
                            &lt;includes&gt;*&lt;/includes&gt;
                            &lt;outputDirectory&gt;
                                ${project.build.directory}/macosx/${appName}.app/Contents/Resources/Java/lib
                            &lt;/outputDirectory&gt;
                        &lt;/artifactItem&gt;
                    &lt;/artifactItems&gt;
                    &lt;!-- other configurations here --&gt;
                &lt;/configuration&gt;
            &lt;/execution&gt;
        &lt;/executions&gt;
    &lt;/plugin&gt;

For more info on the CrossPlatformLauncherPlugin, please see
http://devzendo.org/content/xplp/

In your code, you can then:
UIManager.setLookAndFeel("ch.randelshofer.quaqua.QuaquaLookAndFeel");

