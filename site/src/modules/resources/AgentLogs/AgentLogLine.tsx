import type { Interpolation, Theme } from "@emotion/react";
import AnsiToHTML from "ansi-to-html";
import { type Line, LogLine, LogLinePrefix } from "components/Logs/LogLine";
import { type FC, type ReactNode, useMemo } from "react";

// Approximate height of a log line. Used to control virtualized list height.
export const AGENT_LOG_LINE_HEIGHT = 20;

const convert = new AnsiToHTML();

interface AgentLogLineProps {
	line: Line;
	number: number;
	style: React.CSSProperties;
	sourceIcon: ReactNode;
	maxLineNumber: number;
}

export const AgentLogLine: FC<AgentLogLineProps> = ({
	line,
	number,
	maxLineNumber,
	sourceIcon,
	style,
}) => {
	const output = useMemo(() => {
		return convert.toHtml(line.output.split(/\r/g).pop() as string);
	}, [line.output]);

	return (
		<LogLine css={{ paddingLeft: 16 }} level={line.level} style={style}>
			{sourceIcon}
			<LogLinePrefix
				css={styles.number}
				style={{
					minWidth: `${maxLineNumber.toString().length - 1}em`,
				}}
			>
				{number}
			</LogLinePrefix>
			<span
				// biome-ignore lint/security/noDangerouslySetInnerHtml: Output contains HTML to represent ANSI-code formatting
				dangerouslySetInnerHTML={{
					__html: output,
				}}
			/>
		</LogLine>
	);
};

const styles = {
	number: (theme) => ({
		width: 32,
		textAlign: "right",
		flexShrink: 0,
		color: theme.palette.text.disabled,
	}),
} satisfies Record<string, Interpolation<Theme>>;
