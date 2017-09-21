package org.devzendo.quaquatester;

import com.apple.eawt.AppEvent;
import com.apple.eawt.Application;
import com.apple.eawt.QuitHandler;
import com.apple.eawt.QuitResponse;
import org.apache.log4j.Logger;
import org.devzendo.commonapp.gui.Beautifier;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.lang.reflect.InvocationTargetException;

/**
 * Copyright (C) 2008-2017 Matt Gumbley, DevZendo.org http://devzendo.org
 * <p>
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * <p>
 * http://www.apache.org/licenses/LICENSE-2.0
 * <p>
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
public class Main {
    private static final Logger logger = Logger.getLogger(Main.class);
    public static void main(String[] args) {
        final String javaLibraryPath = System.getProperty("java.library.path");
        final StringBuilder sb = new StringBuilder();
        sb.append("java.library.path is '" + javaLibraryPath + "'\n");
        boolean found = false;
        final String[] paths = javaLibraryPath.split(":");
        for (final String path : paths) {
            final File quaqua = new File(path, "libquaqua.jnilib");
            final boolean exists = quaqua.exists();
            sb.append(quaqua.getAbsolutePath() + "? " + exists + "\n");
            found |= exists;
        }
        sb.append("Quaqua JNI library exists there (for Mac OS X)? " + found);

        try {
            SwingUtilities.invokeAndWait(new Runnable() {
                @Override
                public void run() {
                    Beautifier.makeBeautiful();

                    final JFileChooser mFileChooser = new JFileChooser();
                    mFileChooser.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
                    mFileChooser.setMultiSelectionEnabled(false);
                    mFileChooser.setControlButtonsAreShown(false);

                    final JFrame frame = new JFrame("Quaqua test");
                    frame.setDefaultCloseOperation(WindowConstants.DISPOSE_ON_CLOSE);
                    frame.setLayout(new BorderLayout());

                    final JPanel panel = new JPanel(new BorderLayout());
                    frame.add(panel, BorderLayout.CENTER);
                    final JTextArea label = new JTextArea(10, 50);
                    label.setText(sb.toString());
                    panel.add(label, BorderLayout.NORTH);
                    final JButton button = new JButton("Click me");
                    panel.add(button, BorderLayout.SOUTH);
                    button.addActionListener(new ActionListener() {
                        @Override
                        public void actionPerformed(final ActionEvent e) {
                            mFileChooser.showOpenDialog(panel);
                        }
                    });
                    frame.pack();


                    final Application application = Application.getApplication();
                    application.setQuitHandler(new QuitHandler() {
                        @Override
                        public void handleQuitRequestWith(final AppEvent.QuitEvent quitEvent, final QuitResponse quitResponse) {
                            SwingUtilities.invokeLater(new Runnable() {
                                @Override
                                public void run() {
                                    logger.info("Disposing main frame");
                                    frame.dispose();
                                    logger.info("System exit");
                                    System.exit(0);
                                    logger.info("still here!");
                                }
                            });
                        }
                    });


                    frame.setVisible(true);
                    logger.info("finished gui setup");
                }
            });
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        }
        logger.info("Finished main thread");
    }
}
